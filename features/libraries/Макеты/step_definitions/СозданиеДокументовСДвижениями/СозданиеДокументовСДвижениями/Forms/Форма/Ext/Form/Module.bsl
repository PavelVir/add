﻿
#Область Служебные_функции_и_процедуры

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
	//Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,ОписаниеШага,ТипШага,Транзакция,Параметр);
	
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯУдаляюВсеЗаписиРегистрСведенийПодчиненРегистратору(Парам01)","ЯУдаляюВсеЗаписиРегистрСведенийПодчиненРегистратору","И я удаляю все записи РегистрСведенийПодчиненРегистратору ""РСПодчиненРегистраторуПериодический""","","");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВМетаданныхЕстьРегистрНакопления(Парам01)","ВМетаданныхЕстьРегистрНакопления","Когда в метаданных есть РегистрНакопления ""РегистрНакопления1""","","");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯУдаляюВсеЗаписиРегистрНакопления(Парам01)","ЯУдаляюВсеЗаписиРегистрНакопления","И я удаляю все записи РегистрНакопления ""РегистрНакопления1""","","");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВБазеНетЗаписейРегистрНакопления(Парам01)","ВБазеНетЗаписейРегистрНакопления","И в базе нет записей РегистрНакопления ""РегистрНакопления1""","","");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВБазеПоявилсяХотяБыОднаЗаписьРегистрНакопления(Парам01)","ВБазеПоявилсяХотяБыОднаЗаписьРегистрНакопления","Тогда В базе появился хотя бы одна запись РегистрНакопления ""РегистрНакопления1""","","");

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

#КонецОбласти



#Область Работа_со_сценариями

&НаКлиенте
// Процедура выполняется перед началом каждого сценария
Процедура ПередНачаломСценария() Экспорт
	
КонецПроцедуры

&НаКлиенте
// Процедура выполняется перед окончанием каждого сценария
Процедура ПередОкончаниемСценария() Экспорт
	
КонецПроцедуры

#КонецОбласти


///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаСервереБезКонтекста
Функция ЯУдаляюВсеЗаписиРегистрСведенийСервер(ВидРС)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Регистратор
		|ИЗ
		|	РегистрСведений.РегистрСведений1 КАК РегистрСведений1";

	Запрос.Текст = СтрЗаменить(Запрос.Текст,"РегистрСведений1",ВидРС);
	Результат = Запрос.Выполнить();


	НаборЗаписей = РегистрыСведений[ВидРС].СоздатьНаборЗаписей();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаДетальныеЗаписи.Регистратор);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Очистить();
		НаборЗаписей.Записать();
	КонецЦикла;
	
	
	
КонецФункции	

&НаКлиенте
//И я удаляю все записи РегистрСведенийПодчиненРегистратору "РСПодчиненРегистраторуПериодический"
//@ЯУдаляюВсеЗаписиРегистрСведенийПодчиненРегистратору(Парам01)
Процедура ЯУдаляюВсеЗаписиРегистрСведенийПодчиненРегистратору(ВидРС) Экспорт
	
	ЯУдаляюВсеЗаписиРегистрСведенийСервер(ВидРС);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВМетаданныхЕстьРНСервер(ВидРН)
	Нашел = Ложь;
	Для каждого Элем Из Метаданные.РегистрыНакопления Цикл
		Имя = Элем.Имя;
		Если НРег(Имя) = НРег(ВидРН) Тогда
			Нашел = Истина;
			Прервать;
		КонецЕсли;	 
	КонецЦикла;
	
	Возврат Нашел; 
КонецФункции	

&НаКлиенте
//Когда в метаданных есть РегистрНакопления "РегистрНакопления1"
//@ВМетаданныхЕстьРегистрНакопления(Парам01)
Процедура ВМетаданныхЕстьРегистрНакопления(ВидРН) Экспорт
	
	Нашел = ВМетаданныхЕстьРНСервер(ВидРН);
	
	Ванесса.ПроверитьРавенство(Нашел,Истина,"В метаданных есть вид РН " + ВидРН);
	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЯУдаляюВсеЗаписиРегистрНакопленияСервер(ВидРН)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Регистратор
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1 КАК РегистрНакопления1";

	Запрос.Текст = СтрЗаменить(Запрос.Текст,"РегистрНакопления1",ВидРН);
	Результат = Запрос.Выполнить();


	НаборЗаписей = РегистрыНакопления[ВидРН].СоздатьНаборЗаписей();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаДетальныеЗаписи.Регистратор);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Очистить();
		НаборЗаписей.Записать();
	КонецЦикла;
			
КонецФункции	

&НаКлиенте
//И я удаляю все записи РегистрНакопления "РегистрНакопления1"
//@ЯУдаляюВсеЗаписиРегистрНакопления(Парам01)
Процедура ЯУдаляюВсеЗаписиРегистрНакопления(ВидРН) Экспорт
	
	ЯУдаляюВсеЗаписиРегистрНакопленияСервер(ВидРН);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВБазеНетЗаписейРНСервер(ВидРН)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	*
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1 КАК РегистрНакопления1";

	Запрос.Текст = СтрЗаменить(Запрос.Текст,"РегистрНакопления1",ВидРН);
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат 1;
	КонецЦикла;
	
	Возврат 0;

КонецФункции	

&НаКлиенте
//И в базе нет записей РегистрНакопления "РегистрНакопления1"
//@ВБазеНетЗаписейРегистрНакопления(Парам01)
Процедура ВБазеНетЗаписейРегистрНакопления(ВидРН) Экспорт
	КолЭлементов = ВБазеНетЗаписейРНСервер(ВидРН);
	Ванесса.ПроверитьРавенство(КолЭлементов,0,"Не должно быть записей");
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВБазеПоявилсяХотяБыОднаЗаписьРНСервер(ВидРН)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	*
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1 КАК РегистрНакопления1";

	Запрос.Текст = СтрЗаменить(Запрос.Текст,"РегистрНакопления1",ВидРН);
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат 1;
	КонецЦикла;
	
	Возврат 0;

КонецФункции	


&НаКлиенте
//Тогда В базе появился хотя бы одна запись РегистрНакопления "РегистрНакопления1"
//@ВБазеПоявилсяХотяБыОднаЗаписьРегистрНакопления(Парам01)
Процедура ВБазеПоявилсяХотяБыОднаЗаписьРегистрНакопления(ВидРН) Экспорт
	КолЭлементов = ВБазеПоявилсяХотяБыОднаЗаписьРНСервер(ВидРН);
	Ванесса.ПроверитьНеРавенство(КолЭлементов,0,"В базе должны быть записи");
КонецПроцедуры
