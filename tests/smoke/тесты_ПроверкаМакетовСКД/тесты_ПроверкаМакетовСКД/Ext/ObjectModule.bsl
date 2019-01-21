﻿Перем КонтекстЯдра;
Перем Утверждения;

#Область Основные_процедуры_теста

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
		
	ДобавитьОбщиеМакеты(НаборТестов);
	
	ДобавитьМакетМетаданных(НаборТестов);	
	
КонецПроцедуры

#Область События_юнит_тестирования

Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти

Процедура ТестДолжен_ПроверитьМакетСКД(ИмяМенеджера, ИмяОбьекта, ИмяМакета) Экспорт
	
	Менеджер = МенеджерОбьектаПоИмени(ИмяМенеджера);
	
	СхемаКомпоновкиДанных = Менеджер[ИмяОбьекта].ПолучитьМакет(СокрЛП(ИмяМакета));
	
	ПроверитьСхемуСКД(СхемаКомпоновкиДанных);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьОбщийМакетСКД(ИмяМакета) Экспорт
	
	СхемаКомпоновкиДанных = ПолучитьОбщийМакет(ИмяМакета);
	
	ПроверитьСхемуСКД(СхемаКомпоновкиДанных);
	
КонецПроцедуры

Процедура ДобавитьОбщиеМакеты(НаборТестов)
	
	мНаборов = Новый Массив;
	
	Для Каждого ОбщийМакет ИЗ Метаданные.ОбщиеМакеты Цикл
		
		Если ОбщийМакет.ТипМакета <> Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			Продолжить;
		КонецЕсли;
		
		мНаборов.Добавить(
			Новый Структура("ИмяПроцедуры, Параметры, Представление",
				"ТестДолжен_ПроверитьОбщийМакетСКД",
				НаборТестов.ПараметрыТеста(ОбщийМакет.Имя),
				СтрШаблон("ОбщиеМакеты: %1", ОбщийМакет.Имя)));	
		
	КонецЦикла;
			
	Если мНаборов.Количество() > 0 Тогда
		
		НаборТестов.НачатьГруппу("ОбщиеМакеты", Ложь);
		
		Для Каждого Набор ИЗ мНаборов Цикл
			
			НаборТестов.Добавить(Набор.ИмяПроцедуры, Набор.Параметры, Набор.Представление);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьМакетМетаданных(НаборТестов)
	
	ПроверяемыеОбъекты = ПроверяемыеМетаданные();
	
	Для Каждого ПроверяемыйОбъект ИЗ ПроверяемыеОбъекты Цикл
		
		мНаборов = Новый Массив;
		
		Для Каждого ТекОбъект ИЗ Метаданные[ПроверяемыйОбъект] Цикл
			
			ИмяМенеджера = ВРЕГ(ПроверяемыйОбъект);
			
			Для Каждого ТекДанныеМакета ИЗ ТекОбъект.Макеты Цикл
				
				Если ТекДанныеМакета.ТипМакета <> Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
					Продолжить;
				КонецЕсли;
				
				мНаборов.Добавить(
					Новый Структура("ИмяПроцедуры, Параметры, Представление",
						"ТестДолжен_ПроверитьМакетСКД",
						НаборТестов.ПараметрыТеста(ИмяМенеджера, ТекОбъект.Имя, ТекДанныеМакета.Имя),
						СтрШаблон("%1: %2", ТекОбъект.Имя, ТекДанныеМакета.Имя)));
				
			КонецЦикла;
			
		КонецЦикла;
		
		Если мНаборов.Количество() > 0 Тогда
			
			НаборТестов.НачатьГруппу(ПроверяемыйОбъект, Ложь);
			
			Для Каждого Набор ИЗ мНаборов Цикл
				
				НаборТестов.Добавить(Набор.ИмяПроцедуры, Набор.Параметры, Набор.Представление);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьСхемуСКД(СхемаКомпоновкиДанных)

	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
	
	//Тут проходит синтаксический анализ запроса.
    КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
КонецПроцедуры

Функция ПроверяемыеМетаданные()
	
	ПроверяемыеОбъекты = Новый Массив();
	ПроверяемыеОбъекты.Добавить("Справочники");
	ПроверяемыеОбъекты.Добавить("Документы");
	ПроверяемыеОбъекты.Добавить("Обработки");
	ПроверяемыеОбъекты.Добавить("Отчеты");
	ПроверяемыеОбъекты.Добавить("Перечисления");
	ПроверяемыеОбъекты.Добавить("ПланыВидовХарактеристик");
	ПроверяемыеОбъекты.Добавить("ПланыСчетов");
	ПроверяемыеОбъекты.Добавить("ПланыВидовРасчета");
	ПроверяемыеОбъекты.Добавить("РегистрыСведений");
	ПроверяемыеОбъекты.Добавить("РегистрыНакопления");
	ПроверяемыеОбъекты.Добавить("РегистрыБухгалтерии");
	ПроверяемыеОбъекты.Добавить("РегистрыРасчета");
	ПроверяемыеОбъекты.Добавить("БизнесПроцессы");
	ПроверяемыеОбъекты.Добавить("Задачи");
	
	Возврат ПроверяемыеОбъекты;
	
КонецФункции

Функция МенеджерОбьектаПоИмени(Знач ИмяМенеджера)
	
	Менеджер = Неопределено;
	
	Если ИмяМенеджера = "ПЛАНЫОБМЕНА" Тогда
		Менеджер = ПланыОбмена;
		
	ИначеЕсли ИмяМенеджера = "СПРАВОЧНИКИ" Тогда
		Менеджер = Справочники;
		
	ИначеЕсли ИмяМенеджера = "ДОКУМЕНТЫ" Тогда
		Менеджер = Документы;
		
	ИначеЕсли ИмяМенеджера = "ЖУРНАЛЫДОКУМЕНТОВ" Тогда
		Менеджер = ЖурналыДокументов;
		
	ИначеЕсли ИмяМенеджера = "ПЕРЕЧИСЛЕНИЯ" Тогда
		Менеджер = Перечисления;
		
	ИначеЕсли ИмяМенеджера = "ОТЧЕТЫ" Тогда
		Менеджер = Отчеты;
		
	ИначеЕсли ИмяМенеджера = "ОБРАБОТКИ" Тогда
		Менеджер = Обработки;
		
	ИначеЕсли ИмяМенеджера = "ПЛАНЫВИДОВХАРАКТЕРИСТИК" Тогда
		Менеджер = ПланыВидовХарактеристик;
		
	ИначеЕсли ИмяМенеджера = "ПЛАНЫСЧЕТОВ" Тогда
		Менеджер = ПланыСчетов;
		
	ИначеЕсли ИмяМенеджера = "ПЛАНЫВИДОВРАСЧЕТА" Тогда
		Менеджер = ПланыВидовРасчета;
		
	ИначеЕсли ИмяМенеджера = "РЕГИСТРЫСВЕДЕНИЙ" Тогда
		Менеджер = РегистрыСведений;
		
	ИначеЕсли ИмяМенеджера = "РЕГИСТРЫНАКОПЛЕНИЯ" Тогда
		Менеджер = РегистрыНакопления;
		
	ИначеЕсли ИмяМенеджера = "РЕГИСТРЫБУХГАЛТЕРИИ" Тогда
		Менеджер = РегистрыБухгалтерии;
		
	ИначеЕсли ИмяМенеджера = "РЕГИСТРЫРАСЧЕТА" Тогда
		Менеджер = РегистрыРасчета;
		
	ИначеЕсли ИмяМенеджера = "БИЗНЕСПРОЦЕССЫ" Тогда
		Менеджер = БизнесПроцессы;
		
	ИначеЕсли ИмяМенеджера = "ЗАДАЧИ" Тогда
		Менеджер = Задачи;
		
	КонецЕсли;
	
	Возврат Менеджер;
КонецФункции