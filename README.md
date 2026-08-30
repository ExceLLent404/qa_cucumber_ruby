# QA cucumber ruby

## Настройка окружения и запуск тестов

Для настройки окружения и запуска тестов необходимо иметь установленные [Docker](https://docs.docker.com/engine/install/) и [Docker Compose](https://docs.docker.com/compose/install/).

Для первоначальной настройки окружения выполните следующую команду в терминале, находясь в директории проекта

```bash
docker compose run --rm tests bundle install
```

Для запуска тестов выполните команду

```bash
docker compose run --rm tests bundle exec cucumber
```

Увидеть процесс UI тестирования можно по ссылке [localhost:7900/?autoconnect=1&resize=scale](http://localhost:7900/?autoconnect=1&resize=scale).
