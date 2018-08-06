﻿//Перем КонтекстЯдра;
Перем Ожидаем;
Перем ВременныеФайлы;
Перем КомандныйФайл;

Перем Лог;
Перем ЛогВключен;

Перем RegExp_ПолучитьСписокТестов;
Перем RegExp_КонецФункции_ПолучитьСписокТестов;

Перем ПолноеИмяБраузераТестов;
Перем ПолныйПутьКФайлуБраузераТестов;

//{ Интерфейс конвертера

Функция Инициализация(СлужебныеПараметрыЯдра = Неопределено) Экспорт

	Если ТипЗнч(СлужебныеПараметрыЯдра) = Тип("Структура") Тогда
		СлужебныеПараметрыЯдра.Свойство("ПолноеИмяБраузераТестов", ПолноеИмяБраузераТестов);
		СлужебныеПараметрыЯдра.Свойство("ПолныйПутьКФайлуБраузераТестов", ПолныйПутьКФайлуБраузераТестов);
	КонецЕсли;

	ВременныеФайлы = СоздатьУтилиту("ВременныеФайлы");
	КомандныйФайл = СоздатьУтилиту("КомандныйФайл");
	Ожидаем = СоздатьУтилиту("УтвержденияBDD");
	
	РегулярныеВыражения_Инициализация (RegExp_ПолучитьСписокТестов, "^\s*((?:procedure)|(?:function)|(?:процедура)|(?:функция))\s+(получитьсписоктестов)\s*\(([\wА-яёЁ\d]+)\s*\)\s+экспорт");
	РегулярныеВыражения_Инициализация (RegExp_КонецФункции_ПолучитьСписокТестов, "^\s*конецфункции");
	
	ВключитьЛог(Ложь);
	Лог = "";
		
КонецФункции

Функция ПреобразоватьКаталог(КаталогТестов, ИскатьВПодкаталогах = Ложь) Экспорт
	Рез = СоздатьСтруктуруРезультатаПреобразования();
	
	Файлы = НайтиФайлы(КаталогТестов, "*.epf", ИскатьВПодкаталогах);
	Возврат ПреобразоватьФайлы(Файлы, Истина);
КонецФункции

Функция ПреобразоватьФайлы(НаборФайлов, НужноДелатьКопию = Истина) Экспорт
	Рез = СоздатьСтруктуруРезультатаПреобразования();
	
	Если НаборФайлов.Количество() = 0 Тогда
		Возврат Рез;
	КонецЕсли;
	Для Каждого Файл Из НаборФайлов Цикл
		Попытка
			РезультатыПоФайлу = ПреобразоватьФайл(Файл, Истина);
			ДобавитьЧислаВНаборИзДругогоНабора(Рез, РезультатыПоФайлу);
		Исключение
			Сообщить(Файл.ПолноеИмя + " : " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЦикла;
	Возврат Рез;
КонецФункции

Функция ПреобразоватьФайл(ИсходныйФайл, НужноДелатьКопию = Истина) Экспорт
	Рез = СоздатьСтруктуруРезультатаПреобразования();
	Рез.НайденоВнешнихОбработок = 1;
	
	ИмяКаталогаСборки = ПодготовитьВременныйКаталогДляСборкиРазборки();

	ФайлУтилиты = ПолучитьУтилитуСборкиРазборки(ИмяКаталогаСборки);
	МассивОписанийФайловМодулей = РазобратьФайлТестаНаИсходники(ИмяКаталогаСборки, ИсходныйФайл, ФайлУтилиты);
	НовыйМассивОписанийФайловМодулей = НайтиФайлыМодуляТестаВИсходниках(МассивОписанийФайловМодулей);
	Если НовыйМассивОписанийФайловМодулей.Количество() = 0 Тогда
		Возврат Рез;
	КонецЕсли;
	Рез.НайденоФайловТестов = 1;
	
	Для Каждого ОписаниеФайлаМодуля  Из НовыйМассивОписанийФайловМодулей Цикл
		ФайлМодуляТеста = ОписаниеФайлаМодуля.Файл;
		ИсходныйТекст = ПолучитьИсходныйТекстМодуляТеста(ФайлМодуляТеста);
		ЭтоОбычнаяФорма = ОписаниеФайлаМодуля.БылРазборДополнительногоКонтейнера;
		КонечныйТекст = ПреобразоватьТекстМодуляТестаВФормат_v4_reborn(ИсходныйТекст, ЭтоОбычнаяФорма);
		ЗаписатьНовыйТекстМодуляТестаВИсходникМодуляФайлТеста(ФайлМодуляТеста, КонечныйТекст);
	КонецЦикла;
	Если НужноДелатьКопию Тогда
		ФайлКопии = СделатьКопиюФайла(ИсходныйФайл);
	КонецЕсли;
	ПодменитьФайлВерсийВИсходниках(ИмяКаталогаСборки, ИсходныйФайл, ФайлУтилиты);
	
	СобратьФайлТеста(ИмяКаталогаСборки, ИсходныйФайл, ФайлУтилиты, МассивОписанийФайловМодулей);
	Рез.КонвертированоТестов = 1;
	
	УдалитьВременныеФайлы();
	Возврат Рез;
КонецФункции

Процедура УдалитьВременныеФайлы() Экспорт
	ВременныеФайлы.Удалить();
КонецПроцедуры

Процедура ВключитьЛог(НовоеЗначение = Истина) Экспорт
	ЛогВключен = НовоеЗначение = Истина;
КонецПроцедуры

Функция ПолучитьЛог() Экспорт
	Возврат Лог;
КонецФункции

//}

//{ приватные методы

Функция СоздатьУтилиту(ИмяУтилиты)
	
	КонтекстЯдра = ПолучитьКонтекстЯдраНаСервере();
	
	Возврат КонтекстЯдра.СоздатьОбъектПлагина(ИмяУтилиты);
	
КонецФункции

Функция ПодготовитьВременныйКаталогДляСборкиРазборки()
	ИмяКаталогаСборки = ВременныеФайлы.СоздатьКаталог_();
	Возврат ИмяКаталогаСборки;
КонецФункции

Функция ПолучитьУтилитуСборкиРазборки(ИмяКаталогаСборки)
	МакетУтилиты = ПолучитьМакет("v8unpack");
	
	Файл = Новый Файл(ИмяКаталогаСборки+"\v8unpack.exe");
	
	МакетУтилиты.Записать(Файл.ПолноеИмя);
	Возврат Файл;
КонецФункции

Функция РазобратьФайлТестаНаИсходники(ИмяКаталогаСборки, ФайлТеста, ФайлУтилиты) 
	МассивОписанийФайловМодулей = Новый Массив;
	
	ИмяКаталогаИсходниковФайла = ФайлТеста.ИмяБезРасширения;
	
	Файл = КомандныйФайл.ОткрытьФайл(ВременныеФайлы.НовоеИмяФайла("bat"));
	КомандныйФайл.Добавить("cd /d " + ИмяКаталогаСборки);
	КомандныйФайл.Добавить(ФайлУтилиты.ПолноеИмя + " -unpack """ + ФайлТеста.ПолноеИмя + """ " + ИмяКаталогаИсходниковФайла + " > "+ИмяКаталогаИсходниковФайла+".unpack.log");
	КодВозврата = КомандныйФайл.ВыполнитьКоманду();
	Ожидаем.Что(КодВозврата, "КодВозврата первый -unpack").Равно(0);
	
	Файлы = НайтиФайлы(ИмяКаталогаСборки+"/"+ИмяКаталогаИсходниковФайла, "*.0.data");
	Ожидаем.Что(Файлы.Количество(), "Должны быть файлы, а их нет").Больше(0);
	Для Каждого БинарныйФайл Из Файлы Цикл
		ИмяФайлаИсходников = БинарныйФайл.Имя + ".txt";
		
		Файл = КомандныйФайл.ОткрытьФайл(ВременныеФайлы.НовоеИмяФайла("bat"));
		КомандныйФайл.Добавить("cd /d " + БинарныйФайл.Путь);
		КомандныйФайл.Добавить(ФайлУтилиты.ПолноеИмя + " -undeflate " + БинарныйФайл.Имя + " " + ИмяФайлаИсходников + " > "+БинарныйФайл.ИмяБезРасширения+".unpack.log");
		КодВозврата = КомандныйФайл.ВыполнитьКоманду();
		Ожидаем.Что(КодВозврата, "КодВозврата -undeflate "+БинарныйФайл.Имя).Равно(0);
		
		Файл = КомандныйФайл.ОткрытьФайл(ВременныеФайлы.НовоеИмяФайла("bat"));
		КомандныйФайл.Добавить("cd /d " + БинарныйФайл.Путь);
		КомандныйФайл.Добавить(ФайлУтилиты.ПолноеИмя + " -unpack " + ИмяФайлаИсходников + " " + БинарныйФайл.ИмяБезРасширения + " > "+БинарныйФайл.ИмяБезРасширения+".unpack.log");
		КодВозврата = КомандныйФайл.ВыполнитьКоманду();
		
		ОписаниеИсходника = Новый Структура("ИсходныйФайл", БинарныйФайл);
		ОписаниеИсходника.Вставить("ФайлДополнительногоКонтейнера", Новый Файл(БинарныйФайл.Путь +"/"+ИмяФайлаИсходников));
		Если КодВозврата = 4294967245 Тогда //UnpackToFolder. This is not V8 file!
			ОписаниеИсходника.Вставить("БылРазборДополнительногоКонтейнера", Ложь);
			ОписаниеИсходника.Вставить("Файл", Новый Файл(БинарныйФайл.Путь +"/"+ИмяФайлаИсходников));
			МассивОписанийФайловМодулей.Добавить(ОписаниеИсходника);
			Продолжить;
		ИначеЕсли КодВозврата = 0 Тогда
			ОписаниеИсходника.Вставить("БылРазборДополнительногоКонтейнера", Истина);
			НужныйФайл = Новый Файл(БинарныйФайл.Путь +"/"+БинарныйФайл.ИмяБезРасширения+"/text.data");
			Если НужныйФайл.Существует() Тогда
				ОписаниеИсходника.Вставить("Файл", НужныйФайл);
				МассивОписанийФайловМодулей.Добавить(ОписаниеИсходника);
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		Ожидаем.Что(КодВозврата, "КодВозврата второй -unpack "+БинарныйФайл.Имя).Равно(0);
	КонецЦикла;
	Возврат МассивОписанийФайловМодулей;
	
	//разборка
	//@echo off
	//v8unpack.exe  -unpack ШаблонТестаУФ.epf .\ШаблонТестаУФ
	//v8unpack.exe -undeflate .\ШаблонТестаУФ\727eda5f-558c-428b-86d2-3421c52f4c50.0.data .\ШаблонТестаУФ\Module.txt
	//v8unpack.exe -unpack .\ШаблонТестаУФ\Module.txt .\ШаблонТестаУФ\Module

	//v8unpack.exe -undeflate .\ШаблонТестаУФ\ba335523-e6ff-4049-91a9-5f97f7ab0a0b.0.data .\ШаблонТестаУФ\UF.txt
	//rem v8unpack.exe -unpack .\ШаблонТестаУФ\UF.txt .\ШаблонТеста\UF

	//сборка 
	//rem @echo off
	//v8unpack.exe -pack .\ШаблонТеста\Module .\ШаблонТеста\NewModule.txt 
	//v8unpack.exe -deflate .\ШаблонТеста\NewModule.txt .\ШаблонТеста\727eda5f-558c-428b-86d2-3421c52f4c50.0.data 
	//v8unpack.exe  -pack .\ШаблонТеста ШаблонТеста2.epf 
КонецФункции

Функция ПолучитьИмяКонтейнераИзФайла(БинарныйФайл)
	Возврат БинарныйФайл.Имя + ".txt";	
КонецФункции

Функция НайтиФайлыМодуляТестаВИсходниках(МассивОписанийФайловМодулей)
	НовыйМассивОписанийФайловМодулей = Новый Массив;
	Для Каждого ОписаниеИсходника Из МассивОписанийФайловМодулей Цикл
		Файл = ОписаниеИсходника.Файл;
		Текст = Новый ЧтениеТекста(Файл.ПолноеИмя, КодировкаТекста.UTF8);
		Стр = Текст.ПрочитатьСтроку();
		Пока Стр <> Неопределено Цикл
			Если РегулярныеВыражения_Проверка(RegExp_ПолучитьСписокТестов, Стр) Тогда
				НовыйМассивОписанийФайловМодулей.Добавить(ОписаниеИсходника);
				Прервать;
			КонецЕсли;
			Стр = Текст.ПрочитатьСтроку();
		КонецЦикла;		
	КонецЦикла;
	Возврат НовыйМассивОписанийФайловМодулей;;
КонецФункции

Функция ПолучитьИсходныйТекстМодуляТеста(ФайлМодуляТеста)
	Возврат ПолучитьТекстФайла(ФайлМодуляТеста);
КонецФункции

Функция ПреобразоватьТекстМодуляТестаВФормат_v4_reborn(ИсходныйТекст, ЭтоОбычнаяФорма)
	ЕстьДвеДвойныеКавычки = Не ЭтоОбычнаяФорма;
	Возврат ПреобразоватьТекст(ИсходныйТекст, ЭтоОбычнаяФорма, ЕстьДвеДвойныеКавычки);
КонецФункции

Функция ЗаписатьНовыйТекстМодуляТестаВИсходникМодуляФайлТеста(ФайлМодуляТеста, КонечныйТекст)
	ЗаписатьТекстВФайл(ФайлМодуляТеста, КонечныйТекст);
КонецФункции

Функция СделатьКопиюФайла(ИсходныйФайл)
	ФайлКопии = Новый Файл(ИсходныйФайл.Путь+"/"+ИсходныйФайл.ИмяБезРасширения +".orig.epf");
	КопироватьФайл(ИсходныйФайл.ПолноеИмя, ФайлКопии.ПолноеИмя);
	Ожидаем.Что(ФайлКопии.Существует(), "не удалось сделать копию-файла для файла "+ИсходныйФайл.ПолноеИмя +", ожидали файл копии "+ФайлКопии.ПолноеИмя).ЭтоИстина();
	Возврат ФайлКопии;
КонецФункции

Процедура ПодменитьФайлВерсийВИсходниках(ИмяКаталогаСборки, ИсходныйФайл, ФайлУтилиты)
	НовыйФайлВерсий = Новый Файл(ВременныеФайлы.НовоеИмяФайла("txt"));
	ЗаписатьТекстВФайл(НовыйФайлВерсий, "{1,0}");
	
	Файл = КомандныйФайл.ОткрытьФайл(ВременныеФайлы.НовоеИмяФайла("bat"));
	КомандныйФайл.Добавить("cd /d " + ИмяКаталогаСборки+"/"+ИсходныйФайл.ИмяБезРасширения);
	КомандныйФайл.Добавить(ФайлУтилиты.ПолноеИмя + " -deflate " + НовыйФайлВерсий.ПолноеИмя + " versions.data >> versions.data.pack.log");
	
	КодВозврата = КомандныйФайл.ВыполнитьКоманду();
	Ожидаем.Что(КодВозврата, "КодВозврата versions -pack").Равно(0);	
КонецПроцедуры

Функция СобратьФайлТеста(ИмяКаталогаСборки, ФайлТеста, ФайлУтилиты, МассивОписанийФайловМодулей)
	УдалитьФайлы(ФайлТеста.ПолноеИмя);
	Ожидаем.Что(ФайлТеста.Существует(), "исходный файл теста не удалось удалить "+ФайлТеста.ПолноеИмя).ЭтоЛожь();
	
	Файл = КомандныйФайл.ОткрытьФайл(ВременныеФайлы.НовоеИмяФайла("bat"));
	КомандныйФайл.Добавить("cd /d " + ИмяКаталогаСборки+"/"+ФайлТеста.ИмяБезРасширения);
	Для Каждого ОписаниеИсходника Из МассивОписанийФайловМодулей Цикл
		РазобранныйФайл = ОписаниеИсходника.Файл;
		ИсходныйФайл = ОписаниеИсходника.ИсходныйФайл;
		ФайлДополнительногоКонтейнера = ОписаниеИсходника.ФайлДополнительногоКонтейнера;
		Если ОписаниеИсходника.БылРазборДополнительногоКонтейнера Тогда
			КомандныйФайл.Добавить(ФайлУтилиты.ПолноеИмя + " -pack " + РазобранныйФайл.Путь + " " + ФайлДополнительногоКонтейнера.Имя + " > "+РазобранныйФайл.Имя +".pack.log");
		КонецЕсли;
		
		КомандныйФайл.Добавить(ФайлУтилиты.ПолноеИмя + " -deflate " + ФайлДополнительногоКонтейнера.Имя + " " + ИсходныйФайл.Имя + " >> "+РазобранныйФайл.Имя +".pack.log");
	КонецЦикла;
	ИмяКаталогаИсходниковФайла = ФайлТеста.ИмяБезРасширения;
	
	КомандныйФайл.Добавить("cd ..");
	КомандныйФайл.Добавить(ФайлУтилиты.ПолноеИмя + " -pack " + ИмяКаталогаИсходниковФайла + " """ + ФайлТеста.ПолноеИмя + """ > "+ИмяКаталогаИсходниковФайла+".pack.log");
	КодВозврата = КомандныйФайл.ВыполнитьКоманду();
	Ожидаем.Что(КодВозврата, "КодВозврата первый -pack").Равно(0);	
КонецФункции

Функция ПреобразоватьТекст(Знач Исходный, ЭтоОбычнаяФорма, ЕстьДвеДвойныеКавычки) Экспорт
	
	ОписаниеМетодаПолучитьСписокТестов = ПолучитьОписаниеМетода_ПолучитьСписокТестов(Исходный);
	Если Не ЗначениеЗаполнено(ОписаниеМетодаПолучитьСписокТестов) Тогда
		Возврат "";
	КонецЕсли;
	
	СтрокаРез = ИсправитьОписаниеТестов(Исходный, ОписаниеМетодаПолучитьСписокТестов, ЭтоОбычнаяФорма, ЕстьДвеДвойныеКавычки);
	СтрокаРез = ПодменитьБазовыеУтверждения(СтрокаРез, ОписаниеМетодаПолучитьСписокТестов);
	Возврат СтрокаРез;
КонецФункции

Функция ПолучитьОписаниеМетода_ПолучитьСписокТестов(Знач ИсходныйТекст) Экспорт
	ОписаниеМетода = Новый Структура("Начало, Конец, ИмяПараметра_КонтекстЯдра, ТелоМетода, КоллекцияТестов");
	
	Группировки = РегулярныеВыражения_Выполнить(RegExp_ПолучитьСписокТестов, ИсходныйТекст);
	Если Не ЗначениеЗаполнено(Группировки) Тогда
		ДобавитьЛог("Не удалось найти экспортную процедуру ПолучитьСписокТестов с одним параметром.");
		Возврат Неопределено;
	КонецЕсли;
	
	Группировка_Процедура = Группировки[0];
	Ожидаем.Что(Группировка_Процедура.ПодВыражения.Количество(), "Ожидаем, что количество найденных элементов при поиске ПолучитьСписокТестов равно образцу, а это не так").Равно(3);
	Если Сред(ИсходныйТекст, Группировка_Процедура.Начало, 1) = Символы.ПС Тогда
		Начало = Группировка_Процедура.Начало + 1;
	КонецЕсли;
	Если Сред(ИсходныйТекст, Начало, 1) = Символы.ПС Тогда
		Начало = Начало + 1;
	КонецЕсли;
	ОписаниеМетода.Вставить("Начало", Начало);
	ОписаниеМетода.Вставить("ИмяПараметра_КонтекстЯдра", Группировка_Процедура.ПодВыражения[2]);
	ДобавитьЛог("ОписаниеМетода.ИмяПараметра_КонтекстЯдра "+ОписаниеМетода.ИмяПараметра_КонтекстЯдра);
	
	НачалоКодаПроцедуры = Группировка_Процедура.Начало + Группировка_Процедура.Длина + 2;
	
	Группировки_КонецПроцедуры = РегулярныеВыражения_Выполнить(RegExp_КонецФункции_ПолучитьСписокТестов, Сред(ИсходныйТекст, НачалоКодаПроцедуры));
	Если Не ЗначениеЗаполнено(Группировки_КонецПроцедуры) Тогда
		ВызватьИсключение "Не удалось найти конец процедуры для процедуры ПолучитьСписокТестов с одним параметром.";
	КонецЕсли;
	
	ГруппировкаДляКонецПроцедуры = Группировки_КонецПроцедуры[0];
	ТекстМетодаПолучитьСписокТестов = Сред(ИсходныйТекст, НачалоКодаПроцедуры, ГруппировкаДляКонецПроцедуры.Начало - 1); 
	
	ОписаниеМетода.Вставить("Конец", НачалоКодаПроцедуры + ГруппировкаДляКонецПроцедуры.Начало + ГруппировкаДляКонецПроцедуры.Длина + 2);
	ОписаниеМетода.Вставить("ТелоМетода", ТекстМетодаПолучитьСписокТестов);
	
	ДобавитьЛог("ТелоМетода ПолучитьСписокТестов <"+ОписаниеМетода.ТелоМетода+">");
	
	ОписаниеГлобальнойПеременнойКонтекстаЯдра = ПолучитьОписаниеГлобальнойПеременнойКонтекстаЯдра(ИсходныйТекст, ОписаниеМетода);
	ПодтвердитьИмяГлобальнойПеременнойКонтекстаЯдра(ИсходныйТекст, ОписаниеМетода, ОписаниеГлобальнойПеременнойКонтекстаЯдра);
	ОписаниеМетода.Вставить("ОписаниеГлобальнойПеременнойКонтекстаЯдра", ОписаниеГлобальнойПеременнойКонтекстаЯдра);
	
	КоллекцияТестов = ПолучитьКоллекциюТестов(ИсходныйТекст, ОписаниеМетода);
	ОписаниеМетода.Вставить("КоллекцияТестов", КоллекцияТестов);
	
	Возврат ОписаниеМетода;
КонецФункции

Функция ПолучитьОписаниеГлобальнойПеременнойКонтекстаЯдра(Знач ИсходныйТекст, ОписаниеМетода)
	RegExp_ПрисваиваниеКонтекстаЯдра = Неопределено;
	РегулярныеВыражения_Инициализация (RegExp_ПрисваиваниеКонтекстаЯдра, "^\s*([\wА-яёЁ\d]+)\s*=\s*" + ОписаниеМетода.ИмяПараметра_КонтекстЯдра + "\s*;");
	Группировки = РегулярныеВыражения_Выполнить(RegExp_ПрисваиваниеКонтекстаЯдра, ОписаниеМетода.ТелоМетода);
	Если Не ЗначениеЗаполнено(Группировки) Тогда
		ВызватьИсключение "Не удалось найти присваивание параметра контекста ядра.";
	КонецЕсли;
	Группировка = Группировки[0];
	
	Ожидаем.Что(Группировка.ПодВыражения.Количество(), "Ожидаем, что количество найденных элементов при поиске ИмяГлобальнойПеременнойКонтекстаЯдра равно образцу, а это не так").Равно(1);
	
	ОписаниеГлобальнойПеременнойКонтекстаЯдра = Новый Структура("Имя, НачалоОписания, КонецОписания");	

	ОписаниеГлобальнойПеременнойКонтекстаЯдра.Вставить("Имя", Группировка.ПодВыражения[0]);
	
	ДобавитьЛог("предварительно ОписаниеГлобальнойПеременнойКонтекстаЯдра.Имя = " + ОписаниеГлобальнойПеременнойКонтекстаЯдра.Имя);
	Возврат ОписаниеГлобальнойПеременнойКонтекстаЯдра;
КонецФункции

Процедура ПодтвердитьИмяГлобальнойПеременнойКонтекстаЯдра(Знач ИсходныйТекст, ОписаниеМетода, ОписаниеГлобальнойПеременнойКонтекстаЯдра)
	RegExp_ОбъявлениеГлобальнойПеременнойКонтекстаЯдра = Неопределено;
	РегулярныеВыражения_Инициализация (RegExp_ОбъявлениеГлобальнойПеременнойКонтекстаЯдра, "^\s*Перем\s+(" + ОписаниеГлобальнойПеременнойКонтекстаЯдра.Имя + ")\s*[;,]");
	Группировки = РегулярныеВыражения_Выполнить(RegExp_ОбъявлениеГлобальнойПеременнойКонтекстаЯдра, ИсходныйТекст);
	Если Не ЗначениеЗаполнено(Группировки) Тогда
		ВызватьИсключение ("Не удалось найти глобальную переменную контекста ядра.");
	КонецЕсли;
	Группировка = Группировки[0];
	
	Ожидаем.Что(Группировка.ПодВыражения.Количество(), "Ожидаем, что количество найденных элементов при проверке ИмяГлобальнойПеременнойКонтекстаЯдра равно образцу, а это не так").Равно(1);
	ДобавитьЛог("подтверждено ИмяГлобальнойПеременнойКонтекстаЯдра = "+Группировка.ПодВыражения[0]);

	ОписаниеГлобальнойПеременнойКонтекстаЯдра.Вставить("НачалоОписания", Группировка.Начало);
	ОписаниеГлобальнойПеременнойКонтекстаЯдра.Вставить("КонецОписания", Группировка.Начало + Группировка.Длина);
КонецПроцедуры

Функция ПолучитьКоллекциюТестов(Знач ИсходныйТекст, ОписаниеМетода)
	RegExp_ИмяКоллекцииТестов = Неопределено;
	//РегулярныеВыражения_Инициализация (RegExp_ИмяКоллекцииТестов, "\s*([\wА-яёЁ\d]+)\s*=\s*Новый\s+Массив\s*[;\(]([.\s].+)+Возврат\s+([\wА-яёЁ\d]+)");
	РегулярныеВыражения_Инициализация (RegExp_ИмяКоллекцииТестов, "^\s*Возврат\s+([\wА-яёЁ\d]+)");
	Группировки = РегулярныеВыражения_Выполнить(RegExp_ИмяКоллекцииТестов, ОписаниеМетода.ТелоМетода);
	Если Не ЗначениеЗаполнено(Группировки) Тогда
		ВызватьИсключение "Не удалось найти создание коллекции тестов.";
	КонецЕсли;
	Ожидаем.Что(Группировки[0].ПодВыражения.Количество(), "Ожидаем, что количество найденных элементов при поиске ИмяГлобальнойПеременнойКонтекстаЯдра равно образцу, а это не так").Равно(1);
	ИмяПеременнойКоллекцииСпискаТестов = Группировки[0].ПодВыражения[0];
	ДобавитьЛог("ИмяПеременнойКоллекцииСпискаТестов = "+ИмяПеременнойКоллекцииСпискаТестов);
	
	RegExp_ДобавлениеТеста = Неопределено;
	РегулярныеВыражения_Инициализация (RegExp_ДобавлениеТеста, "^\s*" + ИмяПеременнойКоллекцииСпискаТестов + "\s*\.\s*Добавить\(\s*""{1,2}([\wА-яёЁ\d]+)""{1,2}\s*\)\s*;");
	Группировки = РегулярныеВыражения_Выполнить(RegExp_ДобавлениеТеста, ОписаниеМетода.ТелоМетода);
	
	КоллекцияТестов = Новый  Массив;
	Если Не ЗначениеЗаполнено(Группировки) Тогда
		Возврат КоллекцияТестов;
	КонецЕсли;
	Ожидаем.Что(Группировки[0].ПодВыражения.Количество(), "Ожидаем, что количество найденных элементов при поиске ИмяГлобальнойПеременнойКонтекстаЯдра равно образцу, а это не так").Равно(1);
	
	Для Каждого Группировка Из Группировки Цикл
		ИмяТеста = Группировка.ПодВыражения[0];
		ДобавитьЛог("добавляем имя теста = "+ИмяТеста);
		КоллекцияТестов.Добавить(ИмяТеста);
	КонецЦикла;
	
	Возврат КоллекцияТестов;
КонецФункции

Функция ИсправитьОписаниеТестов(Знач Исходный, ОписаниеМетодаПолучитьСписокТестов, ЭтоОбычнаяФорма, ЕстьДвеДвойныеКавычки)
	Ожидаем.Что(Не ЭтоОбычнаяФорма ИЛИ ЭтоОбычнаяФорма И Не ЕстьДвеДвойныеКавычки, "Ожидаем, что ЕстьДвеДвойныеКавычки только в режиме УФ, а сейчас наоборот").ЭтоИстина();
	
	ОписаниеГлобальнойПеременнойКонтекстаЯдра = ОписаниеМетодаПолучитьСписокТестов.ОписаниеГлобальнойПеременнойКонтекстаЯдра;
	ИмяГлобальнойПеременнойКонтекстаЯдра = ОписаниеГлобальнойПеременнойКонтекстаЯдра.Имя;
	
	Макет = ПолучитьМакет("ШаблонТеста");

	ОбластьПеременныеТестирования = ?(ЭтоОбычнаяФорма, Макет.ПолучитьОбласть("ПеременныеТестирования"), Макет.ПолучитьОбласть("ПеременныеТестирования_УФ"));
	ОбластьОписанияТестов = ?(ЭтоОбычнаяФорма, Макет.ПолучитьОбласть("ОписанияТестов"), Макет.ПолучитьОбласть("ОписанияТестов_УФ"));
	Если ЕстьДвеДвойныеКавычки Тогда
		ОбластьОписанияТестов = Макет.ПолучитьОбласть("ОписанияТестов_УФ_ДвеДвойныеКавычки");
	КонецЕсли;
	
	ОбластьДобавитьИмяТеста = Макет.ПолучитьОбласть("ДобавитьИмяТеста");
	ОбластьЗавершениеСпискаТестов = Макет.ПолучитьОбласть("ЗавершениеСпискаТестов");
	ОбластьУФ_НаКлиенте = Макет.ПолучитьОбласть("УФ_НаКлиенте");
	
	ИтоговыйТекст = Новый ТекстовыйДокумент;
	
	ТекстДоОписанияГлобальнойПеременнойКонтекстаЯдра = СокрЛП(Лев(Исходный, ОписаниеГлобальнойПеременнойКонтекстаЯдра.НачалоОписания-1));
	СтрЧислоСтрок_ТекстДо = СтрЧислоСтрок(ТекстДоОписанияГлобальнойПеременнойКонтекстаЯдра);
	Если СтрЧислоСтрок_ТекстДо > 0 и СтрПолучитьСтроку(ТекстДоОписанияГлобальнойПеременнойКонтекстаЯдра, СтрЧислоСтрок_ТекстДо) = "&НаКлиенте" Тогда
		ТекстДо = "";
		Для к = 1 По СтрЧислоСтрок_ТекстДо-1 Цикл
			ТекстДо = ТекстДо + СтрПолучитьСтроку(ТекстДоОписанияГлобальнойПеременнойКонтекстаЯдра, к) + Символы.ПС;
		КонецЦикла;
		ТекстДоОписанияГлобальнойПеременнойКонтекстаЯдра = ТекстДо;
	//Если ТекстДоОписанияГлобальнойПеременнойКонтекстаЯдра = "&НаКлиенте" Тогда
	//	ТекстДоОписанияГлобальнойПеременнойКонтекстаЯдра = "";
	КонецЕсли;
	ДобавитьЛог("текст до описания глобальной переменной контекста "+Символы.ПС+ТекстДоОписанияГлобальнойПеременнойКонтекстаЯдра +"=========="+Символы.ПС);
	
	ДобавитьНепустуюСтрокуКТексту(ИтоговыйТекст, ТекстДоОписанияГлобальнойПеременнойКонтекстаЯдра);
	
	ИтоговыйТекст.Вывести(ОбластьПеременныеТестирования);
	ИтоговыйТекст.ДобавитьСтроку("");
	
	ТекстДоМетодаПолучитьСписокТестов = СокрЛП(Сред(Исходный, ОписаниеГлобальнойПеременнойКонтекстаЯдра.КонецОписания + 1, ОписаниеМетодаПолучитьСписокТестов.Начало-1 - ОписаниеГлобальнойПеременнойКонтекстаЯдра.КонецОписания - 1));
	Если ТекстДоМетодаПолучитьСписокТестов = "&НаКлиенте" Тогда
		ТекстДоМетодаПолучитьСписокТестов = "";
	КонецЕсли;
	ДобавитьЛог("текст до ПолучитьСписокТестов"+Символы.ПС+ТекстДоМетодаПолучитьСписокТестов +"=========="+Символы.ПС);
	ДобавитьНепустуюСтрокуКТексту(ИтоговыйТекст, ТекстДоМетодаПолучитьСписокТестов);
	Если Не ПустаяСтрока(ТекстДоМетодаПолучитьСписокТестов) Тогда
		ИтоговыйТекст.ДобавитьСтроку("");
	КонецЕсли;
	
	ИтоговыйТекст.ДобавитьСтроку(ДобавитьКомментарии("Перем " + ИмяГлобальнойПеременнойКонтекстаЯдра + ";"));
	
	ИсходныйТекстВКомментарии = ДобавитьКомментарии(Сред(Исходный, ОписаниеМетодаПолучитьСписокТестов.Начало, ОписаниеМетодаПолучитьСписокТестов.Конец-ОписаниеМетодаПолучитьСписокТестов.Начало - 2));
	
	ИтоговыйТекст.ДобавитьСтроку(ИсходныйТекстВКомментарии);
	ИтоговыйТекст.ДобавитьСтроку("");
	
	ИтоговыйТекст.Вывести(ОбластьОписанияТестов);
	
	Для Каждого ИмяТеста Из ОписаниеМетодаПолучитьСписокТестов.КоллекцияТестов Цикл
		// из-за невозможности управлять длиной строки-параметра при установке параметра не использую параметры макета текстового документа
		НужныеКавычки = ?(ЕстьДвеДвойныеКавычки, """"+"""", """");
		ВставляемоеИмяТеста = НужныеКавычки + ИмяТеста + НужныеКавычки;
		ДобавляемыйТекст = СтрЗаменить(ОбластьДобавитьИмяТеста.ПолучитьСтроку(2), "%ИмяТеста%", ВставляемоеИмяТеста);
		ИтоговыйТекст.ДобавитьСтроку(ДобавляемыйТекст);
	КонецЦикла;
	ИтоговыйТекст.Вывести(ОбластьЗавершениеСпискаТестов);
	
	ОсновнойТекст = Сред(Исходный, ОписаниеМетодаПолучитьСписокТестов.Конец);
	ИтоговыйТекст.ДобавитьСтроку(ОсновнойТекст);
	
	ДобавитьЛог("ИтоговыйТекст.ПолучитьТекст() = "+Символы.ПС + ИтоговыйТекст.ПолучитьТекст()+"=========="+Символы.ПС);
	
	Возврат ИтоговыйТекст.ПолучитьТекст();
КонецФункции

Функция ПодменитьБазовыеУтверждения(Знач Исходный, ОписаниеМетодаПолучитьСписокТестов)
	НаборОписанийУтвержденийДляЗамены = Новый Структура;
	НаборОписанийУтвержденийДляЗамены.Вставить("БазовыеУтверждения", "Утверждения");
	НаборОписанийУтвержденийДляЗамены.Вставить("ГенераторТестовыхДанных", "ГенераторТестовыхДанных");
	НаборОписанийУтвержденийДляЗамены.Вставить("ЗапросыИзБД", "ЗапросыИзБД");
	НаборОписанийУтвержденийДляЗамены.Вставить("УтвержденияПроверкаТаблиц", "УтвержденияПроверкаТаблиц");
	НаборОписанийУтвержденийДляЗамены.Вставить("КонтекстЯдра", "КонтекстЯдра");
	
	Для Каждого ОписаниеУтверждения Из НаборОписанийУтвержденийДляЗамены Цикл
		НаборБазовыхУтверждений = ПолучитьНаборБазовыхУтверждений(ОписаниеУтверждения.Ключ);
		Исходный = ЗаменитьБазовыеУтвержденияИзНабораУтверждений(Исходный, ОписаниеМетодаПолучитьСписокТестов.ОписаниеГлобальнойПеременнойКонтекстаЯдра.Имя, НаборБазовыхУтверждений, ОписаниеУтверждения.Значение);
	КонецЦикла;
	Возврат Исходный;
КонецФункции

Функция ПолучитьНаборБазовыхУтверждений(ИмяМакетаУтверждений)
	ТекстУтверждений = ПолучитьМакет(ИмяМакетаУтверждений);
	НаборБазовыхУтверждений = Новый Структура;
	Для к = 1 По ТекстУтверждений.КоличествоСтрок() Цикл
		ТекстУтверждения = СокрЛП(ТекстУтверждений.ПолучитьСтроку(к));
		Если ПустаяСтрока(ТекстУтверждения) Тогда
			Продолжить;
		КонецЕсли;
		Описание = ПолучитьОписаниеБазовогоУтверждения(ТекстУтверждения);
		НаборБазовыхУтверждений.Вставить(Описание.Исходное, Описание);
	КонецЦикла;
	Возврат НаборБазовыхУтверждений;
КонецФункции

Функция ПолучитьОписаниеБазовогоУтверждения(ТекстУтверждения)
	Результат = Новый Структура("Исходное, Результирующее, ЕстьЗамена");
	
	МассивСтрок = РазложитьСтрокуВМассивПодстрок(ТекстУтверждения, "=");
	
	Если МассивСтрок.Количество() = 1 Тогда
		Результат.Вставить("Исходное", ТекстУтверждения);
		Результат.Вставить("Результирующее", ТекстУтверждения);
		Результат.Вставить("ЕстьЗамена", Ложь);
	ИначеЕсли МассивСтрок.Количество() = 2 Тогда
		Результат.Вставить("Исходное", МассивСтрок[0]);
		Результат.Вставить("Результирующее", МассивСтрок[1]);
		Результат.Вставить("ЕстьЗамена", Истина);
	Иначе
		ВызватьИсключение "Неверный формат базового утверждения. В макете разрешено либо название утверждения (например, ПроверитьРавенство) либо описание замены (например, ПрерватьТест=КонтекстЯдра.ВызватьОшибкуПроверки)";
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ЗаменитьБазовыеУтвержденияИзНабораУтверждений(Знач Исходный, ОписаниеГлобальнойПеременнойКонтекстаЯдра, НаборБазовыхУтверждений, ИмяНовойПеременнойУтверждений)
	
	НаборЗамен = Новый Соответствие;
	ШаблонУтверждений = "(";
	Для Каждого Структура Из НаборБазовыхУтверждений Цикл
		ИсходноеУтверждение = Структура.Ключ;
		ОписаниеУтверждения = Структура.Значение;
		
		ШаблонУтверждений = ШаблонУтверждений + "(" + ОписаниеГлобальнойПеременнойКонтекстаЯдра + "\s*\.\s*("+ИсходноеУтверждение+")\s*\()|";
		
		Если ОписаниеУтверждения.ЕстьЗамена Тогда
			НаборЗамен.Вставить(НРег(ОписаниеГлобальнойПеременнойКонтекстаЯдра + "." + ИсходноеУтверждение + "("), ОписаниеУтверждения.Результирующее + "(");
		Иначе
			НаборЗамен.Вставить(НРег(ОписаниеГлобальнойПеременнойКонтекстаЯдра + "." + ИсходноеУтверждение + "("), ИмяНовойПеременнойУтверждений + "." + ИсходноеУтверждение + "(");
		КонецЕсли;
	КонецЦикла;
	НаборЗамен = Новый ФиксированноеСоответствие(НаборЗамен); // для точной проверки свойств через НаборЗамен[ТекстУтверждения], а не переустановки значения свойство в Неопределено
	
	ШаблонУтверждений = Лев(ШаблонУтверждений, СтрДлина(ШаблонУтверждений) - 1);
	ШаблонУтверждений = ШаблонУтверждений + ")+";
	ДобавитьЛог(ИмяНовойПеременнойУтверждений + " ШаблонУтверждений " + ШаблонУтверждений);
	
	RegExp_ШаблонУтверждений = Неопределено;
	РегулярныеВыражения_Инициализация (RegExp_ШаблонУтверждений, ШаблонУтверждений);
	Группировки = РегулярныеВыражения_Выполнить(RegExp_ШаблонУтверждений, Исходный);
	
	Если Не ЗначениеЗаполнено(Группировки) Тогда
		ДобавитьЛог("Не удалось найти использование утверждений в тексте теста");
		Возврат Исходный;
	КонецЕсли;
	
	//обход в обратном порядке, чтобы не было проблем с индексом по строке в Лев, Сред
	Для н = -Группировки.Количество()+1 По 0 Цикл
		к = -н;
		Группировка = Группировки[к];

		ТекстУтверждения = Группировка.ПодВыражения[0];
		ДобавитьЛог(ИмяНовойПеременнойУтверждений + " найден текст утверждения имя теста = "+ТекстУтверждения);
		ДобавитьЛог(ИмяНовойПеременнойУтверждений + " найден НаборЗамен["+НРег(ТекстУтверждения)+"] = "+НаборЗамен[НРег(ТекстУтверждения)]);
		ЛеваяЧасть = Лев(Исходный, Группировка.Начало);
		ПраваяЧасть = Сред(Исходный, Группировка.Начало + Группировка.Длина + 1);
		
		Исходный = ЛеваяЧасть + НаборЗамен[НРег(ТекстУтверждения)] + ПраваяЧасть;
	КонецЦикла;
	
	ДобавитьЛог(ИмяНовойПеременнойУтверждений + " После ЗаменитьБазовыеУтвержденияИзНабораУтверждений ============== "+Символы.ПС + Исходный);
	Возврат Исходный;
КонецФункции

Функция ДобавитьКомментарии(Строка)
	Рез = Новый ТекстовыйДокумент;
	Для к=1 По СтрЧислоСтрок(Строка) Цикл
		Рез.ДобавитьСтроку("//"+СтрПолучитьСтроку(Строка, к));
	КонецЦикла;
	Возврат СокрЛП(Рез.ПолучитьТекст());
КонецФункции

Процедура ДобавитьНепустуюСтрокуКТексту(Текст, Строка)
	Если Не ПустаяСтрока(Строка) Тогда
		Текст.ДобавитьСтроку(Строка);
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьТекстФайла(Файл)
	Текст = Новый ЧтениеТекста(Файл.ПолноеИмя, КодировкаТекста.UTF8);
	Стр = Текст.Прочитать();
	Возврат Стр;
КонецФункции

Процедура ЗаписатьТекстВФайл(Файл, Строка)
	Текст = Новый ЗаписьТекста(Файл.ПолноеИмя, КодировкаТекста.UTF8);
	Текст.Записать(Строка);
	Текст.Закрыть();
КонецПроцедуры

Процедура ДобавитьЛог(Сообщение)
	Если ЛогВключен Тогда
		Лог = Лог + Сообщение + Символы.ПС;
	КонецЕсли;
КонецПроцедуры

Функция СоздатьСтруктуруРезультатаПреобразования()
	Возврат Новый Структура("НайденоВнешнихОбработок,НайденоФайловТестов,КонвертированоТестов",0,0,0);
КонецФункции

Процедура ДобавитьЧислаВНаборИзДругогоНабора(ИсходныйНабор, ДобавляемыйНабор)
	Для Каждого КлючЗначение Из ДобавляемыйНабор  Цикл
		Ключ = КлючЗначение.Ключ;
		ИсходныйНабор.Вставить(Ключ, ИсходныйНабор[Ключ] + КлючЗначение.Значение);
	КонецЦикла;
КонецПроцедуры

// Разбивает строку на несколько строк по разделителю. Разделитель может иметь любую длину.
// Общий модуль СтроковыеФункцииКлиентСервер.
//
// Параметры:
//  Строка                 - Строка - текст с разделителями;
//  Разделитель            - Строка - разделитель строк текста, минимум 1 символ;
//  ПропускатьПустыеСтроки - Булево - признак необходимости включения в результат пустых строк.
//    Если параметр не задан, то функция работает в режиме совместимости со своей предыдущей версией:
//     - для разделителя-пробела пустые строки не включаются в результат, для остальных разделителей пустые строки
//       включаются в результат.
//     - если параметр Строка не содержит значащих символов или не содержит ни одного символа (пустая строка), то в
//       случае разделителя-пробела результатом функции будет массив, содержащий одно значение "" (пустая строка), а
//       при других разделителях результатом функции будет пустой массив.
//
//
// Возвращаемое значение:
//  Массив - массив строк.
//
// Примеры:
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",") - возвратит массив из 5 элементов, три из которых  - пустые строки;
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",", Истина) - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок(" один   два  ", " ") - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок("") - возвратит пустой массив;
//  РазложитьСтрокуВМассивПодстрок("",,Ложь) - возвратит массив с одним элементом "" (пустой строкой);
//  РазложитьСтрокуВМассивПодстрок("", " ") - возвратит массив с одним элементом "" (пустой строкой);
//
Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено)
	
	Результат = Новый Массив;
	
	// для обеспечения обратной совместимости
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Результат.Добавить(Подстрока);
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Результат.Добавить(Строка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

//}

//{ RegExp

Процедура РегулярныеВыражения_Инициализация (RegExp, Шаблон, ИскатьДоПервогоСовпадения = Ложь, МногоСтрок = Истина, ИгнорироватьРегистр = Истина) Экспорт

    Если RegExp = Неопределено Тогда
        RegExp = Новый COMОбъект("VBScript.RegExp");
    КонецЕсли;

    RegExp.MultiLine = МногоСтрок;                  // истина — текст многострочный, ложь — одна строка
    RegExp.Global = Не ИскатьДоПервогоСовпадения;   // истина — поиск по всей строке, ложь — до первого совпадения
    RegExp.IgnoreCase = ИгнорироватьРегистр;        // истина — игнорировать регистр строки при поиске
    RegExp.Pattern = Шаблон;                        // шаблон (регулярное выражение)

КонецПроцедуры

Функция РегулярныеВыражения_Проверка(RegExp, ПроверяемыйТекст)

    Возврат RegExp.Test(ПроверяемыйТекст);

КонецФункции

Функция РегулярныеВыражения_Выполнить(RegExp, АнализируемыйТекст) Экспорт

    РезультатАнализаСтроки = RegExp.Execute(АнализируемыйТекст);

    Группировки = Новый Массив;

    Для Каждого Выражение Из РезультатАнализаСтроки Цикл
        СтруктураВыражение = Новый Структура ("Начало, Длина, Значение, ПодВыражения", Выражение.FirstIndex, Выражение.Length,Выражение.Value);

        МассивПодВыражений = Новый Массив;
        Для Каждого ПодВыражение Из Выражение.SubMatches Цикл
            МассивПодВыражений.Добавить(ПодВыражение);
        КонецЦикла;
        СтруктураВыражение.ПодВыражения = МассивПодВыражений;

        Группировки.Добавить (СтруктураВыражение);

    КонецЦикла;

    Возврат Группировки;

КонецФункции

Функция РегулярныеВыражения_Заменить(RegExp, АнализируемыйТекст, ЗаменяемыйТекст) Экспорт

    Рез = RegExp.Replace(АнализируемыйТекст, ЗаменяемыйТекст);
    Возврат Рез;

КонецФункции

//}

// { Подсистема конфигурации xUnitFor1C

Функция ПолучитьКорневойКаталогФреймворка(Знач АнализируемыйПутьККаталогу)
	
	РезультатПоиска = НайтиФайлы(АнализируемыйПутьККаталогу, "xddTestRunner.epf");
	Если РезультатПоиска.Количество() = 0 Тогда
		ВышестоящийКаталог = ПолучитьПутьВышестоящегоКаталога(АнализируемыйПутьККаталогу);
		Возврат ПолучитьКорневойКаталогФреймворка(ВышестоящийКаталог);	
	Иначе
		Возврат РезультатПоиска.Получить(0).Путь;
	КонецЕсли;
			
КонецФункции
Функция ПолучитьПутьВышестоящегоКаталога(Знач ТекущийПутьККаталогу)
	
	МассивРазделителей = Новый Массив;
	МассивРазделителей.Добавить("/");
	МассивРазделителей.Добавить("\");
	
	ПоследнийСимвол = Прав(ТекущийПутьККаталогу, 1);
	Если НЕ МассивРазделителей.Найти(ПоследнийСимвол) = Неопределено Тогда
		ДлинаПутьБезПоследнегоРазделителя = СтрДлина(ТекущийПутьККаталогу) - 1;
		ТекущийПутьККаталогу = Лев(ТекущийПутьККаталогу, ДлинаПутьБезПоследнегоРазделителя);	
	КонецЕсли;
	
	Пока СтрДлина(ТекущийПутьККаталогу) > 0 Цикл
		
		ПоследнийСимвол = Прав(ТекущийПутьККаталогу, 1);
		Если НЕ МассивРазделителей.Найти(ПоследнийСимвол) = Неопределено Тогда
			Прервать;
		Иначе
			ДлинаПутьБезПоследнегоСимвола = СтрДлина(ТекущийПутьККаталогу) - 1;
			ТекущийПутьККаталогу = Лев(ТекущийПутьККаталогу, ДлинаПутьБезПоследнегоСимвола);	
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТекущийПутьККаталогу;
	
КонецФункции

Функция ПолучитьКонтекстЯдраНаСервере()
	
	// Получаем доступ к серверному контексту обработки с использованием 
	// полного имени метаданных браузера тестов. Иначе нет возможности получить
	// доступ к серверному контексту ядра, т.к. изначально вызов был выполнен на клиенте.
	// При передаче на сервер клиентский контекст теряется.
	КонтекстЯдра = Неопределено;
	МетаданныеЯдра = Метаданные.НайтиПоПолномуИмени(ПолноеИмяБраузераТестов);
	Если НЕ МетаданныеЯдра = Неопределено
		И Метаданные.Обработки.Содержит(МетаданныеЯдра) Тогда
		ИмяОбработкиКонекстаЯдра = СтрЗаменить(ПолноеИмяБраузераТестов, "Обработка", "Обработки");
		Выполнить("КонтекстЯдра = " + ИмяОбработкиКонекстаЯдра + ".Создать()");	
	Иначе
		ИмяОбработкиКонекстаЯдра = СтрЗаменить(ПолноеИмяБраузераТестов, "ВнешняяОбработка", "ВнешниеОбработки");
		ИмяОбработкиКонекстаЯдра = СтрЗаменить(ИмяОбработкиКонекстаЯдра, ".", Символы.ПС);
		МенеджерОбъектов = СтрПолучитьСтроку(ИмяОбработкиКонекстаЯдра, 1);
		ИмяОбъекта = СтрПолучитьСтроку(ИмяОбработкиКонекстаЯдра, 2);
		Выполнить("КонтекстЯдра = " + МенеджерОбъектов + ".Создать("""+ИмяОбъекта+""")");	
	КонецЕсли;
	
	Возврат КонтекстЯдра;
	
КонецФункции

// } Подсистема конфигурации xUnitFor1C