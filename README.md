# SwiftUI-Days
<img alt="Static Badge" src="https://img.shields.io/badge/Swift_Version-6.0-orange">
<img alt="Static Badge" src="https://img.shields.io/badge/iOS_Version-17-blue">

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
make install
```
- После этого вы сможете запускать другие команды из `Makefile` для форматирования кода, генерации скриншотов и обновления зависимостей

## Что можно делать в приложении
1. Создавать/изменять/сортировать/удалять записи
2. Посмотреть, сколько дней назад произошло записанное событие
3. Отправить обратную связь о приложении
4. Создать резервную копию/восстановить данные из резервной копии
5. Удалить все записи разом, если нужно

## Скриншоты  
Для генерации скриншотов используется команда:
```shell
make fastlane
```
### iPhone
| Список записей | Создание новой записи | Сортировка на главном экране |
| --- | --- | --- |
| <img src="./fastlane/screenshots/ru/iPhone 16 Pro Max-1-demoList.png"> | <img src="./fastlane/screenshots/ru/iPhone 16 Pro Max-2-chooseDate.png"> | <img src="./fastlane/screenshots/ru/iPhone 16 Pro Max-3-sortByDate.png"> |

### iPad
| Список записей | Создание новой записи | Сортировка на главном экране |
| --- | --- | --- |
| <img src="./fastlane/screenshots/ru/iPad Pro 13-inch (M4)-1-demoList.png"> | <img src="./fastlane/screenshots/ru/iPad Pro 13-inch (M4)-2-chooseDate.png"> | <img src="./fastlane/screenshots/ru/iPad Pro 13-inch (M4)-3-sortByDate.png"> |
