﻿//начало текста модуля

///////////////////////////////////////////////////
//Служебная часть
///////////////////////////////////////////////////

&НаКлиенте
// контекст фреймворка Vanessa-Behavior
Перем Ванесса;
 
&НаКлиенте
// Структура, в которой хранится состояние сценария между выполнением шагов. Очищается перед выполнением каждого сценария.
Перем Контекст Экспорт;
 
&НаКлиенте
// Структура, в которой можно хранить служебные данные между запусками сценариев. Существует, пока открыта форма Vanessa-Behavior.
Перем КонтекстСохраняемый Экспорт;

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;
	
	ВсеТесты = Новый Массив;

	//описание параметров
	//Ванесса.ДобавитьШагВМассивТестов(МассивТестов, Снипет, ИмяПроцедуры,ПредставлениеТеста = Неопределено,ОписаниеШага = Неопределено,ТипШагаДляОписания = Неопределено,ТипШагаВДереве = Неопределено);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ИмеетсяМетаданное(Парам01)","ИмеетсяМетаданное","Дано:  Имеется метаданное ""Справочник.Справочник1""",
		"Проверяет наличие метаданного в метаданных ИБ", "Данные");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВСпискеЭлементовСправочникаСуществуетНеМенееЭлементов(Парам01,Парам02)","ВСпискеЭлементовСправочникаСуществуетНеМенееЭлементов","Тогда В списке элементов справочника ""Справочник1"" существует не менее 1000 элементов",
		"Проверяет наличие указанного количества элементов в справочнике", "Данные");

	Возврат ВсеТесты;
КонецФункции
	
&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета);
КонецФункции
	
&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции



///////////////////////////////////////////////////
//Работа со сценариями
///////////////////////////////////////////////////

&НаКлиенте
// Процедура выполняется перед началом каждого сценария
Процедура ПередНачаломСценария() Экспорт
	
КонецПроцедуры

&НаКлиенте
// Процедура выполняется перед окончанием каждого сценария
Процедура ПередОкончаниемСценария() Экспорт
	
КонецПроцедуры



///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//Дано:  Имеется метаданное "Справочник.Справочник1"
//@ИмеетсяМетаданное(Парам01)
Процедура ИмеетсяМетаданное(ИмяОбъекта) Экспорт
	Ванесса.ПроверитьНеРавенство(ИмеетсяМетаданноеНаСервере(ИмяОбъекта),Ложь);
КонецПроцедуры

&НаСервере
Функция ИмеетсяМетаданноеНаСервере(ИмяОбъекта)
	 Если ТипЗнч(Метаданные.НайтиПоПолномуИмени(ИмяОбъекта))=Тип("Неопределено") Тогда
		 Возврат Ложь;
	 Иначе
		 Возврат Истина;
	 КонецЕсли;	 
КонецФункции

&НаКлиенте
//Тогда В списке элементов справочника "Справочник1" существует не менее 1000 элементов
//@ВСпискеЭлементовСправочникаСуществуетНеМенееЭлементов(Парам01,Парам02)
Процедура ВСпискеЭлементовСправочникаСуществуетНеМенееЭлементов(ИмяСправочника,Количество) Экспорт
	СуществуетЭлементов = ПолучитьКоличествоЭлементовСправочника(ИмяСправочника);
	Ванесса.ПроверитьРавенство(СуществуетЭлементов>Количество, Истина);
КонецПроцедуры

Функция ПолучитьКоличествоЭлементовСправочника(ИмяСправочника)
	
	СуществуетЭлементов = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Счетчик
	|ИЗ
	|	Справочник."+ИмяСправочника+" КАК ИмяСправочника";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда;
	
		СуществуетЭлементов = ВыборкаДетальныеЗаписи.Счетчик;
		
	КонецЕсли;	
	
	Возврат СуществуетЭлементов;
КонецФункции	

