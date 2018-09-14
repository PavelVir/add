﻿Перем ПутьКФайлуПолный Экспорт;// в эту переменную будет установлен правильный клиентский путь к текущему файлу

Перем КонтекстЯдра;
Перем ЭтоLinux;

Перем РегулярноеВыражение;

Перем ТестерЛинукс;

Перем Ожидаем;

// { Plugin interface
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Тип", ВозможныеТипыПлагинов.Утилита);
	Результат.Вставить("Идентификатор", Метаданные().Имя);
	Результат.Вставить("Представление", "РегулярныеВыражения");
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
КонецФункции

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	ЭтоLinux = КонтекстЯдраПараметр.ЭтоLinux;
КонецПроцедуры
// } Plugin interface

// { API

// Установить шаблон регулярного выражения
//
// Параметры:
//  Шаблон	 - Строка - шаблон регулярного выражения
//
Процедура Подготовить(Знач Шаблон) Экспорт
	Если ЭтоLinux Тогда
		ПодготовитьШаблонRexExpLinux(Шаблон);
	Иначе
		Если РегулярноеВыражение = Неопределено Тогда
			Попытка
				РегулярноеВыражение = Новый COMОбъект("VBScript.RegExp");
			Исключение
				ВызватьИсключение "Не удалось создать COMОбъект - VBScript.RegExp";
			КонецПопытки;
		КонецЕсли;

		РегулярноеВыражение.Global = Истина;
		РегулярноеВыражение.Pattern = Шаблон;
		
	КонецЕсли;
КонецПроцедуры

// Проверяет строку на соответствие подготовленному регулярному выражению
//
// Параметры:
//  ПроверяемаяСтрока	 - 	 - 
// 
// Возвращаемое значение:
//   Булево - соответствует или нет 
//
Функция Совпадает(Знач ПроверяемаяСтрока) Экспорт
	ПроверитьПодготовленность();
	Возврат РегулярноеВыражение.Test(ПроверяемаяСтрока);
КонецФункции

// Позволяет проверить соответствие строки "ПроверяемаяСтрока" шаблону "Шаблон"
//	при этом подстрока "Шаблон" может содержать символы *, который означает "любые символы"
//	например СтрокаСоответствуетШаблону("Привет","*вет")
//
// Параметры:
//  ПроверяемаяСтрока	 - Строка	 - 
//  Шаблон				 - Строка	 - 
// 
// Возвращаемое значение:
//   Булево - соответствует или нет 
//
Функция СтрокаСоответствуетШаблону(Знач ПроверяемаяСтрока, Знач Шаблон = "") Экспорт
	
	Если ЗначениеЗаполнено(Шаблон) Тогда
		Шаблон = ПодготовитьШаблонКИспользованиюВРегулярке(Шаблон);
		Если Не ЭтоLinux Тогда
			//для VBScript.RegExp явно указываем что есть начало и конец строки
			Шаблон            = "^" + Шаблон + "$";
		КонецЕсли;
		
		Подготовить(Шаблон);
	КонецЕсли;

	ПроверитьПодготовленность();
	
	Если ЭтоLinux Тогда
		Возврат ПроверитьСтрокуRexExpLinux(ПроверяемаяСтрока);
	Иначе
		Возврат РегулярноеВыражение.Test(ПроверяемаяСтрока);
	КонецЕсли;
КонецФункции

// Подготовить шаблон к использованию в регулярке путем экранирования служебных символов
//	Важно: Символ * в шаблоне трактуется как выражение .+ (любой символ)
//
// Параметры:
//  Шаблон	 - Строка - строка регулярного выражения без экранирования 
// 
// Возвращаемое значение:
//   Строка - подготовленный шаблон регулярного выражения с добавлением экранирования и заменой * 
//
Функция ПодготовитьШаблонКИспользованиюВРегулярке(Знач Шаблон) Экспорт

	// Экранируем все, кроме звездочки. Ее будем трактовать по-своему.
	СпецСимволы = Новый Массив;
	СпецСимволы.Добавить("\");
	СпецСимволы.Добавить("^");
	СпецСимволы.Добавить("$");
	СпецСимволы.Добавить("(");
	СпецСимволы.Добавить(")");
	СпецСимволы.Добавить("<");
	СпецСимволы.Добавить("[");
	СпецСимволы.Добавить("]");
	СпецСимволы.Добавить("{");
	СпецСимволы.Добавить("}");
	СпецСимволы.Добавить("|");
	СпецСимволы.Добавить(">");
	СпецСимволы.Добавить(".");
	СпецСимволы.Добавить("+");
	СпецСимволы.Добавить("?");

	Для Каждого СпецСимвол Из СпецСимволы Цикл
		Шаблон = СтрЗаменить(Шаблон, СпецСимвол, "\" + СпецСимвол);
	КонецЦикла;

	// Трактуем * по-нашему.
	Шаблон = СтрЗаменить(Шаблон, "*", ".+");

	Возврат Шаблон;

КонецФункции

// } API

// { Helpers

Процедура ПроверитьПодготовленность()
	Если ЭтоLinux Тогда
		Значение = ТестерЛинукс;
	Иначе 
		Значение = РегулярноеВыражение;
	КонецЕсли;
	Ожидаем().Что(Значение <> Неопределено, 
		"Ожидали, что регулярное выражение подготовлено, а это не так")
		.ЭтоИстина();
КонецПроцедуры

//взято из https://infostart.ru/public/464971/
Функция ПроверитьСтрокуRexExpLinux(Знач Строка)
	
    Попытка
        ТестерЛинукс.TestItem = Строка;
        Возврат Истина
    Исключение
        Возврат Ложь
    КонецПопытки;
КонецФункции

//взято из https://infostart.ru/public/464971/
Функция ПодготовитьШаблонRexExpLinux(Знач Шаблон)
    Чтение = Новый ЧтениеXML;
    Чтение.УстановитьСтроку(
                "<Model xmlns=""http://v8.1c.ru/8.1/xdto"" xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:type=""Model"">
                |<package targetNamespace=""sample-my-package"">
                |<valueType name=""testtypes"" base=""xs:string"">
                |<pattern>" + Шаблон + "</pattern>
                |</valueType>
                |<objectType name=""TestObj"">
                |<property xmlns:d4p1=""sample-my-package"" name=""TestItem"" type=""d4p1:testtypes""/>
                |</objectType>
                |</package>
                |</Model>");

    Модель = ФабрикаXDTO.ПрочитатьXML(Чтение);
    МояФабрикаXDTO = Новый ФабрикаXDTO(Модель);
    Пакет = МояФабрикаXDTO.Пакеты.Получить("sample-my-package");
    ТестерЛинукс = МояФабрикаXDTO.Создать(Пакет.Получить("TestObj"));
	
	Возврат ТестерЛинукс;
КонецФункции

Функция Ожидаем() 
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	Возврат Ожидаем;	
КонецФункции

// } Helpers
