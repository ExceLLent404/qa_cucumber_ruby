require "capybara/cucumber"
require "selenium-webdriver"

require_relative "helpers/class_extensions"
require_relative "helpers/logger"
require_relative "helpers/api_service"

Capybara.default_driver = :remote_chrome
Capybara.run_server = false
Capybara.default_selector = :xpath

Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--window-size=1920,1080")

  Capybara::Selenium::Driver.new(app, browser: :remote, url: ENV.fetch("CHROME_URL"), options:)
end

module CommonHelpers
  include LoggerHelper

  def downloads_dir
    File.join(Dir.pwd, "tmp", "downloads")
  end

  def api
    @api ||= ApiService.new(
      url: "https://testing4qa.ediweb.ru/api",
      credentials: { login: "c.tester", password: "d3@Ld03kuv?wV3x8Ezb;" }
    )
  end
end

World(CommonHelpers)
