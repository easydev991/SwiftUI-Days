.PHONY: help install format update fastlane

# Цвета ANSI
YELLOW=\033[1;33m
GREEN=\033[1;32m
RED=\033[1;31m
RESET=\033[0m

RUBY_VERSION=3.2.2

help:
	@echo ""
	@echo "Доступные команды Makefile:"
	@echo ""
	@echo "  make help      - Показать это справочное сообщение."
	@echo "  make install   - Проверить и установить все необходимые инструменты и зависимости для проекта:"
	@echo "                   Homebrew, rbenv, Ruby, Bundler, Ruby-гемы (включая fastlane), SwiftFormat."
	@echo "  make format    - Запустить автоматическое форматирование Swift-кода с помощью SwiftFormat."
	@echo "  make update    - Обновить Ruby-зависимости (например, fastlane) до последних версий и обновить Gemfile.lock."
	@echo "  make fastlane  - Запустить fastlane snapshot для генерации скриншотов приложения (использует bundle exec fastlane snapshot)."
	@echo ""
	@echo "Рекомендуется сначала выполнить 'make install' для установки всех зависимостей."
	@echo ""

install:
	@printf "$(YELLOW)Проверка наличия Homebrew...$(RESET)\n"
	@if ! command -v brew >/dev/null 2>&1; then \
		printf "$(YELLOW)Homebrew не установлен.$(RESET)\n"; \
		read -p "Установить Homebrew? (да/нет) " answer; \
		if echo "$${answer}" | grep -iq "^да$$"; then \
			/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
			printf "$(GREEN)Homebrew успешно установлен.$(RESET)\n"; \
		else \
			printf "$(RED)Невозможно продолжить без Homebrew.$(RESET)\n"; \
			exit 1; \
		fi \
	else \
		printf "$(GREEN)Homebrew уже установлен.$(RESET)\n"; \
	fi

	@printf "$(YELLOW)Проверка наличия rbenv...$(RESET)\n"
	@if ! command -v rbenv >/dev/null 2>&1; then \
		printf "$(YELLOW)rbenv не установлен.$(RESET)\n"; \
		read -p "Установить rbenv? (да/нет) " answer; \
		if echo "$${answer}" | grep -iq "^да$$"; then \
			brew install rbenv ruby-build; \
			printf 'eval "$$(rbenv init -)"\n' >> ~/.bash_profile; \
			printf "$(GREEN)rbenv успешно установлен.$(RESET)\n"; \
		else \
			printf "$(RED)Невозможно продолжить без rbenv.$(RESET)\n"; \
			exit 1; \
		fi \
	else \
		printf "$(GREEN)rbenv уже установлен.$(RESET)\n"; \
	fi

	@printf "$(YELLOW)Проверка наличия Ruby версии $(RUBY_VERSION)...$(RESET)\n"
	@if ! rbenv versions | grep -q $(RUBY_VERSION); then \
		printf "$(YELLOW)Ruby $(RUBY_VERSION) не установлен.$(RESET)\n"; \
		read -p "Установить Ruby $(RUBY_VERSION)? (да/нет) " answer; \
		if echo "$${answer}" | grep -iq "^да$$"; then \
			rbenv install $(RUBY_VERSION); \
			printf "$(GREEN)Ruby $(RUBY_VERSION) успешно установлен.$(RESET)\n"; \
		else \
			printf "$(RED)Невозможно продолжить без Ruby $(RUBY_VERSION).$(RESET)\n"; \
			exit 1; \
		fi \
	else \
		printf "$(GREEN)Ruby $(RUBY_VERSION) уже установлен.$(RESET)\n"; \
	fi

	@printf "$(YELLOW)Проверка файла .ruby-version...$(RESET)\n"
	@if [ ! -f .ruby-version ] || [ "$$(cat .ruby-version)" != "$(RUBY_VERSION)" ]; then \
		printf "$(YELLOW)Файл .ruby-version не найден или содержит неверную версию.$(RESET)\n"; \
		read -p "Создать/обновить файл .ruby-version с версией $(RUBY_VERSION)? (да/нет) " answer; \
		if echo "$${answer}" | grep -iq "^да$$"; then \
			echo "$(RUBY_VERSION)" > .ruby-version; \
			printf "$(GREEN)Файл .ruby-version обновлён.$(RESET)\n"; \
		else \
			printf "$(YELLOW)Создание файла .ruby-version пропущено.$(RESET)\n"; \
		fi \
	else \
		printf "$(GREEN)Файл .ruby-version уже корректен.$(RESET)\n"; \
	fi

	@printf "$(YELLOW)Инициализация rbenv и активация Ruby $(RUBY_VERSION) локально...$(RESET)\n"
	@export PATH="$$HOME/.rbenv/bin:$$PATH"; \
	eval "$$(rbenv init -)"; \
	rbenv local $(RUBY_VERSION); \
	rbenv shell $(RUBY_VERSION); \
	printf "$(GREEN)Ruby $(RUBY_VERSION) активирован локально для проекта.$(RESET)\n"

	@printf "$(YELLOW)Проверка наличия Bundler нужной версии...$(RESET)\n"
	@if [ -f Gemfile.lock ]; then \
		BUNDLER_VERSION=$$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1 | xargs); \
		if ! gem list -i bundler -v "$$BUNDLER_VERSION" >/dev/null 2>&1; then \
			printf "$(YELLOW)Bundler версии $$BUNDLER_VERSION не установлен.$(RESET)\n"; \
			read -p "Установить Bundler $$BUNDLER_VERSION? (да/нет) " answer; \
			if echo "$${answer}" | grep -iq "^да$$"; then \
				gem install bundler -v "$$BUNDLER_VERSION"; \
				printf "$(GREEN)Bundler версии $$BUNDLER_VERSION успешно установлен.$(RESET)\n"; \
			else \
				printf "$(RED)Невозможно продолжить без Bundler $$BUNDLER_VERSION.$(RESET)\n"; \
				exit 1; \
			fi \
		else \
			printf "$(GREEN)Bundler версии $$BUNDLER_VERSION уже установлен.$(RESET)\n"; \
		fi \
	else \
		printf "$(YELLOW)Файл Gemfile.lock не найден, пропуск проверки версии Bundler.$(RESET)\n"; \
	fi

	@printf "$(YELLOW)Проверка Ruby-зависимостей из Gemfile...$(RESET)\n"
	@if [ -f Gemfile ]; then \
		if ! bundle check >/dev/null 2>&1; then \
			printf "$(YELLOW)Зависимости не установлены. Выполняется bundle install...$(RESET)\n"; \
			bundle install; \
			if [ $$? -ne 0 ]; then \
				printf "$(RED)Невозможно продолжить без всех Ruby-зависимостей.$(RESET)\n"; \
				exit 1; \
			fi; \
			printf "$(GREEN)Все Ruby-зависимости успешно установлены.$(RESET)\n"; \
		else \
			printf "$(GREEN)Все Ruby-зависимости уже установлены.$(RESET)\n"; \
		fi \
	else \
		printf "$(YELLOW)Файл Gemfile не найден, пропуск установки Ruby-зависимостей.$(RESET)\n"; \
	fi

	@printf "$(YELLOW)Проверка наличия SwiftFormat...$(RESET)\n"
	@if ! command -v swiftformat >/dev/null 2>&1; then \
		printf "$(YELLOW)SwiftFormat не установлен.$(RESET)\n"; \
		read -p "Установить SwiftFormat? (да/нет) " answer; \
		if echo "$${answer}" | grep -iq "^да$$"; then \
			brew install swiftformat; \
			printf "$(GREEN)SwiftFormat успешно установлен.$(RESET)\n"; \
		else \
			printf "$(RED)Невозможно продолжить без SwiftFormat.$(RESET)\n"; \
			exit 1; \
		fi \
	else \
		printf "$(GREEN)SwiftFormat уже установлен.$(RESET)\n"; \
	fi

format:
	@if ! command -v brew >/dev/null 2>&1 || ! command -v swiftformat >/dev/null 2>&1; then \
		$(MAKE) install; \
	fi; \
	if ! command -v brew >/dev/null 2>&1 || ! command -v swiftformat >/dev/null 2>&1; then \
		printf "$(RED)Невозможно выполнить команду без нужных зависимостей$(RESET)\n"; \
		exit 1; \
	fi
	@printf "$(YELLOW)Запуск SwiftFormat...$(RESET)\n"
	@swiftformat .

fastlane:
	@if ! command -v fastlane >/dev/null 2>&1; then \
		printf "$(YELLOW)fastlane не найден. Выполняется установка зависимостей...$(RESET)\n"; \
		$(MAKE) install; \
	fi; \
	if ! command -v fastlane >/dev/null 2>&1; then \
		printf "$(RED)Невозможно выполнить команду без нужных зависимостей$(RESET)\n"; \
		exit 1; \
	fi
	@printf "$(YELLOW)Запуск fastlane snapshot...$(RESET)\n"
	@bundle exec fastlane snapshot

update:
	@printf "$(YELLOW)Обновление fastlane и других Ruby-зависимостей...$(RESET)\n"
	@bundle update
	@printf "$(GREEN)Гемы обновлены. Не забудьте закоммитить новый Gemfile.lock!$(RESET)\n"
