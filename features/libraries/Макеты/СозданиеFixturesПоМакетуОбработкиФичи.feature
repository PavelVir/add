﻿# language: ru

@IgnoreOnWeb

Функционал: Содание fixtures по макету обработки привязанной к фиче
	Как Разработчик
	Я Хочу чтобы чтобы я мог создавать fixtures по макетам, которые находятся в обработке привязанной к фиче
	Чтобы я мог создавать fixtures без программирования
 

Сценарий: Создание fixtures

	Когда Я удаляю все элементы Справочника "Справочник1"
	И     Я создаю fixtures по макету "Макет"
	Тогда В базе появился хотя бы один элемент справочника "Справочник1"

Сценарий: Создание Пользователей ИБ через fixtures
	Когда В базе отсутствует пользователь ИБ "ТестовыйПользователь"
	И Я создаю fixtures по макету "ПользовательИБ"
	Тогда В базе существует пользователь ИБ "ТестовыйПользователь"
	И Я удаляю пользователя ИБ "ТестовыйПользователь"

Сценарий: Создание fixtures по макету из каталога проекта

	Когда Я удаляю все элементы Справочника "Справочник1"
	И     Я создаю fixtures по макету "spec\fixtures\ЗагрузкаОдногоЭлементаСправочника2.mxl"
	Тогда В базе появился хотя бы один элемент справочника "Справочник1"
