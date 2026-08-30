Допустим("папка загрузок пуста") do
  pattern = File.join(downloads_dir, "*")
  Dir.glob(pattern).each { |file| system("sudo -u seluser rm #{file}") }
end

Когда("захожу на страницу {string}") do |url|
  visit url
end

Когда("ввожу в поисковой строке текст {string}") do |text|
  input_field = find("//textarea[@name='q']")
  input_field.set(text)
  input_field.native.send_keys(:enter)
end

Когда("нажимаю кнопку {string}") do |text|
  link = find("//div[@id='page']//a[contains(text(), '#{text}')]")
  link.click
end

Когда("выбираю последний стабильный релиз") do
  link = find("//li[contains(.//text(), 'Стабильные')]//a[contains(@href, '.tar.gz')]", match: :first)
  @downloaded_filename = File.basename(link[:href])
  link.click
end

Тогда("вижу на странице текст {string}") do |text|
  expect(page).to have_content(text)
end

Тогда("попадаю на капчу") do
  expect(page).to have_content("Our systems have detected unusual traffic from your computer network.")
end

Тогда("файл попадает в папку загрузок") do
  path = File.join(downloads_dir, @downloaded_filename)

  wait = Selenium::WebDriver::Wait.new(
    timeout: 10,
    interval: 0.5,
    message: "Превышено время ожидания загрузки файла",
    ignore: RSpec::Expectations::ExpectationNotMetError
  )

  wait.until do
    expect(File).to exist(path).and be_file(path)
    expect(File).not_to be_empty(path)
  end
end
