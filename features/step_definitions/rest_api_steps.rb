Когда("получаю список пользователей") do
  @users = api.get("/users")
  logger.info("Список пользователей получен")
end

Когда(/^проверяю (наличие|отсутствие) в списке пользователя с логином "(\w+\.\w+)"$/) do |presence, login|
  logins = @users.map { |user| user["login"] }

  case presence
  when "наличие"
    expect(logins).to include(login), "Ожидалось найти в списке пользователя с логином \"#{login}\""
  when "отсутствие"
    expect(logins).not_to include(login), "Не ожидалось найти в списке пользователя с логином \"#{login}\""
  end
end

Когда(/^проверяю, что пользователь с логином "(\w+\.\w+)" имеет имя "(\w+)"$/) do |login, name|
  user = @users.select { |user| user["login"] == login }.first
  expect(user["name"]).to eql(name)
end

Когда("создаю пользователя с параметрами:") do |data_table|
  user_data = data_table.rows_hash

  api.post(
    '/users',
    login: user_data["логин"],
    name: user_data["имя"],
    surname: user_data["фамилия"],
    password: user_data["пароль"],
    active: 1
  )
end

Когда(/^обновляю имя пользователя с логином "(\w+\.\w+)" на "(\w+)"$/) do |login, name|
  user = @users.select { |user| user["login"] == login }.first
  api.put("/users/#{user["id"]}", name: name)
  logger.info("Имя пользователя с логином \"#{login}\" обновлено на \"#{name}\"")
end

Когда(/^удаляю пользователя с логином "(\w+\.\w+)"$/) do |login|
  user = @users.select { |user| user["login"] == login }.first
  api.delete("/users/#{user["id"]}")
  logger.info("Удалён пользователь с id=#{user["id"]} и логином \"#{login}\"")
end

Тогда("получаю ошибку с кодом {int}") do |code|
  expect(@response.code).to eql(code)
end
