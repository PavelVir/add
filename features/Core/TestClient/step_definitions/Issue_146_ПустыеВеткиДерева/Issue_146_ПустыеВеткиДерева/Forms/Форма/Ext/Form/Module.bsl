﻿//начало текста модуля

///////////////////////////////////////////////////
//Служебные функции и процедуры
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
	//пример вызова Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,Транзакция,Параметр);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"СоздалКаталогЕслиЕгоНетВКаталоге(Парам01,Парам02)","СоздалКаталогЕслиЕгоНетВКаталоге","И создал каталог ""Temp1\Temp2"" если его нет в каталоге ""features\Core\OpenForm""");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВКаталогеЯЗаписываюФичуСТегом(Парам01,Парам02)","ВКаталогеЯЗаписываюФичуСТегом","И в каталоге ""features\Core\OpenForm\temp1\temp2"" я записываю фичу с тегом ""IgnoreFeature""");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВПолеСИменемЯУказываюПолныйПутьКОтноситльномуКаталогу(Парам01,Парам02)","ВПолеСИменемЯУказываюПолныйПутьКОтноситльномуКаталогу","И В поле с именем ""КаталогФичСлужебный"" я указываю полный путь к относитльному каталогу ""features\Core\OpenForm""");

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
	Если Ванесса.ФайлСуществуетКомандаСистемы(Контекст.ИмяСлужебнойФичи) Тогда
		Ванесса.УдалитьФайлыКомандаСистемы(Контекст.ИмяСлужебнойФичи);
	КонецЕсли;	 
КонецПроцедуры



///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//И создал каталог "Temp1\Temp2" если его нет в каталоге "features\Core\OpenForm"
//@СоздалКаталогЕслиЕгоНетВКаталоге(Парам01,Парам02)
Процедура СоздалКаталогЕслиЕгоНетВКаталоге(ЧтоСоздавать,ГдеСоздавать) Экспорт
	ПолныйПутьГдеСоздавать = Ванесса.Объект.КаталогИнструментов + "\" + ГдеСоздавать + "\" + ЧтоСоздавать;
	
	Если Не Ванесса.ФайлСуществуетКомандаСистемы(ПолныйПутьГдеСоздавать) Тогда
		Ванесса.СоздатьКаталогКомандаСистемы(ПолныйПутьГдеСоздавать);
	КонецЕсли;	 
КонецПроцедуры

&НаКлиенте
//И В поле с именем "КаталогФичСлужебный" я указываю полный путь к относитльному каталогу "features\Core\OpenForm"
//@ВПолеСИменемЯУказываюПолныйПутьКОтноситльномуКаталогу(Парам01,Парам02)
Процедура ВПолеСИменемЯУказываюПолныйПутьКОтноситльномуКаталогу(ИмяПоля,ЧастьПути) Экспорт
	ПутьКФиче = Ванесса.Объект.КаталогИнструментов + "\" + ЧастьПути;
	Ванесса.Шаг("И В открытой форме в поле с именем """ + ИмяПоля + """ я ввожу текст """ + ПутьКФиче + """");
КонецПроцедуры

&НаКлиенте
//И в каталоге "features\Core\OpenForm\temp1\temp2" я записываю фичу с тегом "IgnoreFeature"
//@ВКаталогеЯЗаписываюФичуСТегом(Парам01,Парам02)
Процедура ВКаталогеЯЗаписываюФичуСТегом(Каталог,Тег) Экспорт
	ИмяФайла = Ванесса.Объект.КаталогИнструментов + "\" + Каталог + "\temp.feature";
	
	Контекст.Вставить("ИмяСлужебнойФичи",ИмяФайла);
	
	ЗТ = Новый ЗаписьТекста(ИмяФайла,"UTF-8",,Ложь); 
	ЗТ.ЗаписатьСтроку("@"+Тег); 
	
	ЗТ.Закрыть();
	
КонецПроцедуры

//окончание текста модуля
