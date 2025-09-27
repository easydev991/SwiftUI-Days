.PHONY: help setup setup_hook setup_snapshot setup_fastlane setup_ssh update update_fastlane update_swiftformat format screenshots build test fastlane testflight upload_screenshots

# Цвета и шрифт
YELLOW=\033[1;33m
GREEN=\033[1;32m
RED=\033[1;31m
BOLD=\033[1m
RESET=\033[0m

# Версия Ruby в проекте
RUBY_VERSION=3.2.2

# Версия Swift в проекте
SWIFT_VERSION=6.0

# Глобальные настройки шелла
SHELL := /bin/bash
.ONESHELL:
BUNDLE_EXEC := RBENV_VERSION=$(RUBY_VERSION) bundle exec

## help: Показать это справочное сообщение
help:
	@echo "Доступные команды Makefile:"
	@echo ""
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | \
	awk -F ':' '{printf "  $(BOLD)%s$(RESET):%s\n", $$1, $$2}' BOLD="$(BOLD)" RESET="$(RESET)" | column -t -s ':'
	@echo ""
	@printf "Рекомендуется сначала выполнить команду '$(BOLD)make setup$(RESET)'"
	@echo ""
	
## setup: Проверить и установить все необходимые инструменты и зависимости для проекта (Homebrew, rbenv, Ruby, Bundler, fastlane, swiftformat)
setup:
	@printf "$(YELLOW)Проверка наличия Homebrew...$(RESET)\n"
	@if ! command -v brew >/dev/null 2>&1; then \
		printf "$(YELLOW)Homebrew не установлен. Устанавливаю...$(RESET)\n"; \
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@printf "$(GREEN)Homebrew установлен$(RESET)\n"
	
	@printf "$(YELLOW)Проверка наличия rbenv...$(RESET)\n"
	@if ! command -v rbenv >/dev/null 2>&1; then \
		printf "$(YELLOW)rbenv не установлен. Устанавливаю...$(RESET)\n"; \
		brew install rbenv ruby-build; \
	fi
	@printf "$(GREEN)rbenv установлен$(RESET)\n"
	
	@printf "$(YELLOW)Проверка наличия Ruby версии $(RUBY_VERSION)...$(RESET)\n"
	@if ! rbenv versions | grep -q $(RUBY_VERSION); then \
		printf "$(YELLOW)Ruby $(RUBY_VERSION) не установлен. Устанавливаю...$(RESET)\n"; \
		rbenv install $(RUBY_VERSION); \
	fi
	@printf "$(GREEN)Ruby $(shell rbenv versions | grep $(RUBY_VERSION))$(RESET)\n"
	
	@printf "$(YELLOW)Проверка содержимого файла .ruby-version...$(RESET)\n"
	@if [ ! -f .ruby-version ] || [ "$(shell cat .ruby-version)" != "$(RUBY_VERSION)" ]; then \
		printf "$(YELLOW)Файл .ruby-version не найден или содержит неверную версию. Обновляю...$(RESET)\n"; \
		echo "$(RUBY_VERSION)" > .ruby-version; \
	else \
		printf "$(GREEN)Файл .ruby-version корректно настроен$(RESET)\n"; \
	fi
	
	@RBENV_VERSION=$(RUBY_VERSION) ruby -v >/dev/null 2>&1 || true
	@printf "$(GREEN)Ruby активирован локально для проекта$(RESET)\n"
	
	@printf "$(YELLOW)Проверка наличия Bundler нужной версии...$(RESET)\n"
	@if [ -f Gemfile.lock ]; then \
		BUNDLER_VERSION=$$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1 | xargs); \
		if [ -z "$$BUNDLER_VERSION" ]; then \
			printf "$(RED)Не удалось определить версию Bundler из Gemfile.lock$(RESET)\n"; \
			exit 1; \
		fi; \
		if ! RBENV_VERSION=$(RUBY_VERSION) gem list -i bundler -v "$$BUNDLER_VERSION" >/dev/null 2>&1; then \
			printf "$(YELLOW)Bundler версии $$BUNDLER_VERSION не установлен. Устанавливаю...$(RESET)\n"; \
			RBENV_VERSION=$(RUBY_VERSION) gem install bundler -v "$$BUNDLER_VERSION"; \
		else \
			printf "$(GREEN)Bundler версии $$BUNDLER_VERSION уже установлен$(RESET)\n"; \
		fi; \
	else \
		printf "$(YELLOW)Файл Gemfile.lock не найден, устанавливаю последнюю версию bundler...$(RESET)\n"; \
		RBENV_VERSION=$(RUBY_VERSION) gem install bundler; \
	fi
	
	@printf "$(YELLOW)Проверка наличия Gemfile...$(RESET)\n"
	@if [ ! -f Gemfile ]; then \
		printf "$(YELLOW)Gemfile не найден. Создаю новый Gemfile...$(RESET)\n"; \
		RBENV_VERSION=$(RUBY_VERSION) bundle init; \
		echo "gem 'fastlane'" >> Gemfile; \
		printf "$(GREEN)Gemfile создан и fastlane добавлен в зависимости$(RESET)\n"; \
	else \
		printf "$(GREEN)Gemfile уже существует$(RESET)\n"; \
	fi
	
	@printf "$(YELLOW)Проверка Ruby-зависимостей из Gemfile...$(RESET)\n"
	@if [ -f Gemfile ]; then \
		if ! RBENV_VERSION=$(RUBY_VERSION) bundle check >/dev/null 2>&1; then \
			printf "$(YELLOW)Зависимости не установлены. Выполняется bundle install...$(RESET)\n"; \
			RBENV_VERSION=$(RUBY_VERSION) bundle install; \
			printf "$(GREEN)Все Ruby-зависимости успешно установлены$(RESET)\n"; \
		else \
			printf "$(GREEN)Все Ruby-зависимости уже установлены$(RESET)\n"; \
		fi; \
	else \
		printf "$(YELLOW)Файл Gemfile не найден, пропуск установки Ruby-зависимостей$(RESET)\n"; \
	fi
	
	@printf "$(YELLOW)Проверка наличия swiftformat...$(RESET)\n"
	@if ! command -v swiftformat >/dev/null 2>&1; then \
		printf "$(YELLOW)swiftformat не установлен. Устанавливаю...$(RESET)\n"; \
		brew install swiftformat; \
		printf "$(GREEN)swiftformat успешно установлен$(RESET)\n"; \
	else \
		printf "$(GREEN)swiftformat уже установлен$(RESET)\n"; \
	fi
	
	@printf "$(YELLOW)Проверка наличия файла .swift-version...$(RESET)\n"
	@if [ ! -f .swift-version ]; then \
		printf "$(YELLOW)Файл .swift-version не найден. Создаю с версией $(SWIFT_VERSION)...$(RESET)\n"; \
		echo "$(SWIFT_VERSION)" > .swift-version; \
		printf "$(GREEN).swift-version создан$(RESET)\n"; \
	else \
		printf "$(GREEN)Файл .swift-version уже существует$(RESET)\n"; \
	fi
	
	@$(MAKE) setup_hook
	@$(MAKE) setup_fastlane
	@$(MAKE) setup_snapshot
	@$(MAKE) setup_ssh
	
## setup_hook: Установить pre-push git-хук для проверки форматирования Swift-кода
setup_hook:
	@mkdir -p .git/hooks
	@if [ ! -f .git/hooks/pre-push ]; then \
		printf "$(YELLOW)Установка pre-push git-хука для проверки форматирования Swift-кода...$(RESET)\n"; \
		cp .githooks/pre-push .git/hooks/pre-push; \
		chmod +x .git/hooks/pre-push; \
		printf "$(GREEN)pre-push git-хук установлен!$(RESET)\n"; \
	else \
		printf "$(GREEN)pre-push git-хук уже установлен$(RESET)\n"; \
	fi

## setup_snapshot: Проверить инициализацию fastlane/fastlane snapshot, при необходимости предложить варианты установки
setup_snapshot:
	@printf "$(YELLOW)Проверка установки fastlane...$(RESET)\n"
	@if [ -d fastlane ] && [ -f fastlane/Fastfile ]; then \
		printf "$(GREEN)fastlane уже инициализирован в проекте$(RESET)\n"; \
		if [ ! -f fastlane/Snapfile ]; then \
			printf "$(YELLOW)Snapfile не найден, выполняется инициализация fastlane snapshot...$(RESET)\n"; \
			bundle exec fastlane snapshot init; \
			printf "$(GREEN)fastlane snapshot успешно инициализирован$(RESET)\n"; \
		else \
			printf "$(GREEN)fastlane snapshot уже готов к использованию$(RESET)\n"; \
		fi \
	else \
		printf "$(YELLOW)fastlane не инициализирован в проекте$(RESET)\n"; \
		printf "Выберите действие:\n"; \
		printf "  1 — Установить только fastlane snapshot (Snapfile, без Fastfile)\n"; \
		printf "  2 — Не устанавливать fastlane (вы сможете сделать это вручную)\n"; \
		read -p "Ваш выбор (1/2): " choice; \
		if [ "$$choice" = "1" ]; then \
			if [ ! -f fastlane/Snapfile ]; then \
				mkdir -p fastlane; \
				bundle exec fastlane snapshot init; \
				printf "$(GREEN)fastlane snapshot успешно инициализирован$(RESET)\n"; \
			else \
				printf "$(GREEN)fastlane snapshot уже готов к использованию$(RESET)\n"; \
			fi \
		else \
			printf "$(YELLOW)Вы можете установить fastlane вручную командой:$(RESET)\n"; \
			printf "  make setup_fastlane\n"; \
			printf "$(YELLOW)После этого можно запустить генерацию скриншотов командой 'make screenshots'$(RESET)\n"; \
		fi \
	fi

## setup_ssh: Настраивает SSH-доступ к GitHub (интерактивно: создаст ключ при необходимости, добавит в агент, опционально добавит ключ в аккаунт GitHub)
setup_ssh:
	@printf "$(YELLOW)Проверка SSH-доступа к GitHub...$(RESET)\n"
	@if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then \
		printf "$(GREEN)SSH-доступ к GitHub уже настроен$(RESET)\n"; \
		exit 0; \
	fi
	@# Проверка наличия jq
	@if ! command -v jq >/dev/null 2>&1; then \
		printf "$(YELLOW)Утилита jq не найдена. Устанавливаю через Homebrew...$(RESET)\n"; \
		if command -v brew >/dev/null 2>&1; then brew install jq; else printf "$(RED)Homebrew не найден. Установите jq вручную и повторите.$(RESET)\n"; exit 1; fi; \
	fi
	@# Создание каталога ~/.ssh при необходимости
	@if [ ! -d $$HOME/.ssh ]; then \
		mkdir -p $$HOME/.ssh; \
		printf "$(GREEN)Создана папка ~/.ssh$(RESET)\n"; \
	fi
	@# Создание ключа, если отсутствует (email запрашивается явно)
	@if [ ! -f $$HOME/.ssh/id_ed25519 ]; then \
		read -p "Введите email для комментария ключа: " KEY_EMAIL; \
		while [ -z "$$KEY_EMAIL" ]; do read -p "Email не может быть пустым. Введите email: " KEY_EMAIL; done; \
		printf "$(YELLOW)Создаю новый SSH-ключ id_ed25519...$(RESET)\n"; \
		ssh-keygen -t ed25519 -N "" -C "$$KEY_EMAIL" -f $$HOME/.ssh/id_ed25519; \
	else \
		printf "$(GREEN)SSH-ключ $$HOME/.ssh/id_ed25519 уже существует$(RESET)\n"; \
	fi
	@# Запуск ssh-agent и добавление ключа
	@eval "$$((ssh-agent -s) 2>/dev/null)" >/dev/null || true
	@ssh-add -K $$HOME/.ssh/id_ed25519 >/dev/null 2>&1 || ssh-add $$HOME/.ssh/id_ed25519 >/dev/null 2>&1 || true
	@# Настройка ~/.ssh/config для github.com
	@CONFIG_FILE="$$HOME/.ssh/config"; \
	HOST_ENTRY="Host github.com\n  HostName github.com\n  User git\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile $$HOME/.ssh/id_ed25519\n"; \
	if [ -f "$$CONFIG_FILE" ]; then \
		if ! grep -q "Host github.com" "$$CONFIG_FILE"; then \
			echo "$$HOST_ENTRY" >> "$$CONFIG_FILE"; \
			printf "$(GREEN)Добавлена секция для github.com в ~/.ssh/config$(RESET)\n"; \
		else \
			printf "$(GREEN)Секция для github.com уже есть в ~/.ssh/config$(RESET)\n"; \
		fi; \
	else \
		echo "$$HOST_ENTRY" > "$$CONFIG_FILE"; \
		chmod 600 "$$CONFIG_FILE"; \
		printf "$(GREEN)Создан ~/.ssh/config с секцией для github.com$(RESET)\n"; \
	fi
	@# Предложение добавить публичный ключ в аккаунт GitHub через API
	@printf "$(YELLOW)Добавление публичного ключа в ваш аккаунт GitHub через API...$(RESET)\n"; \
	printf "Требуется персональный токен GitHub с правом 'admin:public_key'.\n"; \
	read -p "Добавить ключ в GitHub через API? [y/N]: " ADD_GH; \
	if [[ "$$ADD_GH" =~ ^[Yy]$$ ]]; then \
		read -p "Введите ваш GitHub Personal Access Token: " TOKEN; \
		read -p "Введите название для SSH-ключа (например, 'work-macbook'): " TITLE; \
		if [ -z "$$TITLE" ]; then TITLE="SwiftUI-Days key"; fi; \
		PUB_KEY=$$(cat $$HOME/.ssh/id_ed25519.pub); \
		DATA=$$(jq -n --arg title "$$TITLE" --arg key "$$PUB_KEY" '{title:$$title, key:$$key}'); \
		RESPONSE=$$(curl -s -w "\n%{http_code}" -X POST "https://api.github.com/user/keys" -H "Accept: application/vnd.github+json" -H "Authorization: token $$TOKEN" -d "$$DATA"); \
		BODY=$$(echo "$$RESPONSE" | sed '$$d'); \
		STATUS=$$(echo "$$RESPONSE" | tail -n 1); \
		if [ "$$STATUS" = "201" ]; then \
			printf "$(GREEN)SSH-ключ успешно добавлен в GitHub$(RESET)\n"; \
		elif [ "$$STATUS" = "422" ]; then \
			printf "$(YELLOW)Ключ уже добавлен или недопустим. Сообщение GitHub:$(RESET)\n"; \
			echo "$$BODY"; \
		else \
			printf "$(RED)Ошибка при добавлении ключа в GitHub (HTTP $$STATUS)$(RESET)\n"; \
			echo "$$BODY"; \
		fi; \
	else \
		printf "$(YELLOW)Пропускаю авто-добавление ключа. Добавьте его вручную: $(RESET)https://github.com/settings/keys\n"; \
	fi
	@printf "$(YELLOW)Проверка соединения с github.com...$(RESET)\n"; \
	ssh -T git@github.com || true
	
## setup_fastlane: Инициализировать fastlane в проекте (пошаговый процесс; при первом разворачивании может быть интерактивным)
setup_fastlane:
	@if [ ! -d fastlane ] || [ ! -f fastlane/Fastfile ]; then \
		printf "$(YELLOW)Инициализация fastlane в проекте...$(RESET)\n"; \
		printf "$(YELLOW)Это интерактивный процесс. Следуйте инструкциям на экране.$(RESET)\n"; \
		$(BUNDLE_EXEC) fastlane init; \
		printf "$(GREEN)fastlane инициализирован!$(RESET)\n"; \
	else \
		printf "$(GREEN)fastlane уже инициализирован$(RESET)\n"; \
	fi

## update: Обновить fastlane и swiftformat (вызывает update_bundle и update_swiftformat)
update: update_fastlane update_swiftformat

## update_fastlane: Обновить только fastlane и его зависимости
update_fastlane:
	@printf "$(YELLOW)Проверка наличия обновлений fastlane и его зависимостей...$(RESET)\n"
	@$(BUNDLE_EXEC) bundle outdated fastlane --parseable | grep . && \
		printf "$(YELLOW)Есть обновления для fastlane или его зависимостей, выполняется обновление...$(RESET)\n"; \
		$(BUNDLE_EXEC) bundle update fastlane; \
		printf "$(GREEN)fastlane и его зависимости обновлены. Не забудьте закоммитить новый Gemfile.lock!$(RESET)\n"; \
	true || printf "$(GREEN)fastlane и его зависимости уже самые свежие$(RESET)\n"

## update_swiftformat: Обновить только swiftformat через Homebrew
update_swiftformat:
	@if ! command -v brew >/dev/null 2>&1; then \
		printf "$(RED)Homebrew не найден. Запустите $(BOLD)make setup$(RESET) для установки зависимостей.\n"; \
		exit 1; \
	fi
	@if brew list --versions swiftformat >/dev/null 2>&1; then \
		printf "$(YELLOW)Проверка обновлений swiftformat...$(RESET)\n"; \
		brew upgrade swiftformat || true; \
	else \
		printf "$(YELLOW)swiftformat не установлен. Устанавливаю...$(RESET)\n"; \
		brew install swiftformat; \
	fi
	@if command -v swiftformat >/dev/null 2>&1; then \
		VER=$$(swiftformat --version 2>/dev/null | awk "{print $$1}"); \
		printf "$(GREEN)swiftformat готов (версия: $$VER)$(RESET)\n"; \
	fi

## format: Запустить автоматическое форматирование Swift-кода с помощью swiftformat
format:
	@if ! command -v swiftformat >/dev/null 2>&1; then \
		if command -v brew >/dev/null 2>&1; then \
			printf "$(YELLOW)swiftformat не найден. Устанавливаю через Homebrew...$(RESET)\n"; \
			brew install swiftformat; \
		else \
			printf "$(RED)swiftformat не найден и Homebrew отсутствует. Запустите $(BOLD)make setup$(RESET) для установки зависимостей.\n"; \
			exit 1; \
		fi; \
	fi
	@printf "$(YELLOW)Форматирование Swift-кода...$(RESET)\n"
	@swiftformat .
	@printf "$(GREEN)Форматирование завершено!$(RESET)\n"

## build: Сборка проекта в терминале
build:
	xcodebuild -project SwiftUI-Days.xcodeproj -scheme SwiftUI-Days -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17' build

## test: Запускает unit-тесты в терминале
test:
	xcodebuild -project SwiftUI-Days.xcodeproj -scheme SwiftUI-Days -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17' test -testPlan SwiftUI-DaysTests

## screenshots: Запустить fastlane snapshot для генерации скриншотов приложения
screenshots:
	@if [ ! -d fastlane ] || [ ! -f fastlane/Fastfile ]; then \
		printf "$(RED)fastlane не инициализирован в проекте$(RESET)\n"; \
		$(MAKE) setup_fastlane; \
		if [ ! -d fastlane ] || [ ! -f fastlane/Fastfile ]; then \
			printf "$(RED)Нужно инициализировать fastlane перед использованием$(RESET)\n"; \
			exit 1; \
		fi; \
	fi
	@printf "$(YELLOW)Запуск fastlane snapshot для генерации скриншотов...$(RESET)\n"
	@$(BUNDLE_EXEC) fastlane screenshots

## upload_screenshots: Загрузить существующие скриншоты в App Store Connect
upload_screenshots:
	@if [ ! -d fastlane ] || [ ! -f fastlane/Fastfile ]; then \
		printf "$(RED)fastlane не инициализирован в проекте$(RESET)\n"; \
		$(MAKE) setup_fastlane; \
		if [ ! -d fastlane ] || [ ! -f fastlane/Fastfile ]; then \
			printf "$(RED)Нужно инициализировать fastlane перед использованием$(RESET)\n"; \
			exit 1; \
		fi; \
	fi
	@printf "$(YELLOW)Загрузка скриншотов в App Store Connect...$(RESET)\n"
	@$(BUNDLE_EXEC) fastlane upload_screenshots

## testflight: Собрать и отправить сборку в TestFlight через fastlane
testflight:
	@printf "$(YELLOW)Сборка и публикация в TestFlight...$(RESET)\n"
	@$(BUNDLE_EXEC) fastlane build_and_upload

## fastlane: Запустить меню команд fastlane
fastlane:
	@if [ ! -d fastlane ] || [ ! -f fastlane/Fastfile ]; then \
		printf "$(RED)fastlane не инициализирован в проекте$(RESET)\n"; \
		$(MAKE) setup_fastlane; \
		if [ ! -d fastlane ] || [ ! -f fastlane/Fastfile ]; then \
			printf "$(RED)Нужно инициализировать fastlane перед использованием$(RESET)\n"; \
			exit 1; \
		fi; \
	fi
	@printf "$(YELLOW)Запуск меню команд fastlane...$(RESET)\n"
	@$(BUNDLE_EXEC) fastlane

.DEFAULT:
	@printf "$(RED)Неизвестная команда: 'make $@'\n$(RESET)"
	@$(MAKE) help
