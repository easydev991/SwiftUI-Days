# SwiftUI-Days
[<img alt="Xcode Version" src="https://img.shields.io/badge/Xcode_Version-26.0-blue">](https://developer.apple.com/xcode/)
[<img alt="Swift Version" src="https://img.shields.io/badge/Swift_Version-6.2-orange">](https://swift.org/)
[<img alt="iOS Version" src="https://img.shields.io/badge/iOS_Version-17-blue">](https://developer.apple.com/ios/)

- Идея приложения в том, чтобы было удобно запоминать события в указанные даты, а потом легко проверить, сколько прошло дней с момента события.
- Это вторая версия моего пет-проекта. Первая версия находится [тут](https://github.com/easydev991/Days), и я не публиковал ее в `AppStore`.

## Начало работы

1. Клонируйте репозиторий
2. В терминале перейдите в папку с проектом
3. Все зависимости можно установить с помощью команд из `Makefile`:
- Ознакомиться с доступными командами можно, выполнив команду:
```shell
make help
```
- Для установки всех зависимостей используйте команду:
```shell
make setup
```
- После этого вы сможете запускать другие команды из `Makefile` для форматирования кода, генерации скриншотов и обновления зависимостей

## Что можно делать в приложении
1. Создавать/изменять/сортировать/удалять записи
2. Посмотреть, сколько дней назад произошло записанное событие
3. Отправить обратную связь о приложении
4. Создать резервную копию/восстановить данные из резервной копии
5. Удалить все записи разом, если нужно

## Скриншоты  
Для автоматической загрузки скриншотов в App Store Connect через fastlane используются устройства, которые соответствуют требованиям App Store Connect по размерам скриншотов:
- **iPhone 15 Pro Max** (1290x2796) - стандартный размер для iPhone
- **iPad Pro (12.9-inch) (6th generation)** (2048x2732) - стандартный размер для iPad

При ручной загрузке в App Store Connect можно использовать скриншоты с любых устройств, но для автоматической загрузки через fastlane нужны именно эти модели.

Для генерации скриншотов используется команда:
```shell
make screenshots
```

Для загрузки скриншотов в App Store Connect используется команда:
```shell
make upload_screenshots
```
### iPhone
| Список записей | Создание новой записи | Выбор опции отображения | Перед сохранением | Сортировка на главном экране |
| --- | --- | --- | --- | --- |
| <img src="./fastlane/screenshots/ru/iPhone 15 Pro Max-1-demoList.png"> | <img src="./fastlane/screenshots/ru/iPhone 15 Pro Max-2-chooseDate.png"> | <img src="./fastlane/screenshots/ru/iPhone 15 Pro Max-3-chooseDisplayOption.png"> | <img src="./fastlane/screenshots/ru/iPhone 15 Pro Max-4-beforeSave.png"> | <img src="./fastlane/screenshots/ru/iPhone 15 Pro Max-5-sortByDate.png"> |

### iPad
| Список записей | Создание новой записи | Выбор опции отображения | Перед сохранением | Сортировка на главном экране |
| --- | --- | --- | --- | --- |
| <img src="./fastlane/screenshots/ru/iPad Pro (12.9-inch) (6th generation)-1-demoList.png"> | <img src="./fastlane/screenshots/ru/iPad Pro (12.9-inch) (6th generation)-2-chooseDate.png"> | <img src="./fastlane/screenshots/ru/iPad Pro (12.9-inch) (6th generation)-3-chooseDisplayOption.png"> | <img src="./fastlane/screenshots/ru/iPad Pro (12.9-inch) (6th generation)-4-beforeSave.png"> | <img src="./fastlane/screenshots/ru/iPad Pro (12.9-inch) (6th generation)-5-sortByDate.png"> |
