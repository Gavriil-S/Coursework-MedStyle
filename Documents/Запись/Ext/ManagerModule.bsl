﻿#Область ПрограммныйИнтерфейс
// Функция - Записи на выделенное время 
// Возвращает выборку записей со статусом
//
// Параметры:
//  СтруктураДанныхЗаписи	 - Структура
// 
// Возвращаемое значение:
//  Булево 
//
Функция ЗаписьНаВыделенноеВремяВозможна(СтруктураДанныхЗаписи) Экспорт
	ЗаписьВозможна = Истина;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Запись.Ссылка КАК Ссылка,
		|	Запись.Дата КАК Дата,
		|	Запись.ДатаОкончания КАК ДатаОкончания
		|ИЗ
		|	Документ.Запись КАК Запись
		|ГДЕ
		|	Запись.Сотрудник = &Сотрудник
		|	И Запись.Статус <> &СтатусОтмены
		|	И Запись.Ссылка <> &ТекущаяЗапись
		|	И Запись.Дата МЕЖДУ &ДатаНач И &ДатаКон";
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(СтруктураДанныхЗаписи.Дата));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(СтруктураДанныхЗаписи.Дата));
	Запрос.УстановитьПараметр("Сотрудник", СтруктураДанныхЗаписи.Сотрудник);
	Запрос.УстановитьПараметр("СтатусОтмены", Перечисления.СтатусЗаявки.Отменено); 
	Запрос.УстановитьПараметр("ТекущаяЗапись", СтруктураДанныхЗаписи.ТекущаяЗапись); 
	Выборка = Запрос.Выполнить().Выбрать(); 
	Пока Выборка.Следующий() Цикл
		Если СтруктураДанныхЗаписи.Дата < Выборка.ДатаОкончания И СтруктураДанныхЗаписи.ДатаОкончания > Выборка.Дата Тогда
			ЗаписьВозможна = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат ЗаписьВозможна;
КонецФункции // ()

// Печать талона
Процедура Печать(ТабДок, Ссылка) Экспорт
	Макет = Документы.Запись.ПолучитьМакет("Печать");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Запись.Дата,
	|	Запись.Клиент,
	|	Запись.МедицинскийЦентр,
	|	Запись.Номер,
	|	Запись.Сотрудник,
	|	Запись.Услуга
	|ИЗ
	|	Документ.Запись КАК Запись
	|ГДЕ
	|	Запись.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Примечание = Макет.ПолучитьОбласть("Примечание");
	ВремяТалона = Макет.ПолучитьОбласть("ВремяТалона");
	
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ОбластьЗаголовок.Параметры.Номер = Выборка.Номер;
		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());
		
		ТабДок.Вывести(Примечание);
		
		ВремяТалона.Параметры.ДатаТалона = ТекущаяДата();
		ТабДок.Вывести(ВремяТалона);

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
КонецПроцедуры

//Печать справки для работы
Процедура ПечатьСправкиДляРаботы(ТабДок, Ссылка) Экспорт
	Макет = Документы.Запись.ПолучитьМакет("СправкаДляРаботы");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Запись.Дата КАК Дата,
	|	Запись.Клиент КАК Клиент,
	|	Запись.МедицинскийЦентр КАК МедЦентр,
	|	Запись.Номер КАК Номер,
	|	Запись.Сотрудник КАК Сотрудник,
	|	Запись.Услуга КАК Услуга,
	|	Запись.МедицинскийЦентр.Адрес КАК Адрес
	|ИЗ
	|	Документ.Запись КАК Запись
	|ГДЕ
	|	Запись.Ссылка В(&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Тело = Макет.ПолучитьОбласть("Тело");
	
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());
		
		ОбластьЗаголовок.Параметры.НомерСправки = Выборка.Номер;
		ТабДок.Вывести(ОбластьЗаголовок);
		
		Тело.Параметры.Клиент = Выборка.Клиент;
		Тело.Параметры.Месяц = Месяц(ТекущаяДата());
		Тело.Параметры.Год = Год(ТекущаяДата());
		Тело.Параметры.Число = "111111";
		ТабДок.Вывести(Тело);

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
КонецПроцедуры 

//Печать справки для спорта
Процедура ПечатьСправкиДляСпорта(ТабДок, Ссылка) Экспорт
	Макет = Документы.Запись.ПолучитьМакет("СправкаДляСпорта");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Запись.Дата,
	|	Запись.Клиент,
	|	Запись.МедицинскийЦентр,
	|	Запись.Номер,
	|	Запись.Сотрудник,
	|	Запись.Услуга
	|ИЗ
	|	Документ.Запись КАК Запись
	|ГДЕ
	|	Запись.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	
	ТабДок.Очистить();
	
	ТабДок.Вывести(ОбластьЗаголовок);
	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		Шапка.Параметры.Клиент = Выборка.Клиент;
		Шапка.Параметры.Месяц = Месяц(ТекущаяДата());
		Шапка.Параметры.Год = Год(ТекущаяДата());
		Шапка.Параметры.День = "111111";
		ТабДок.Вывести(Шапка);
		
		ТабДок.Вывести(Подвал);

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
КонецПроцедуры

//Печать направления
Процедура ПечатьНаправления(ТабДок, Ссылка) Экспорт
	Макет = Документы.Запись.ПолучитьМакет("НаправлениеНаКонсультацию");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Запись.Дата КАК Дата,
	|	Запись.Клиент КАК Клиент,
	|	Запись.МедицинскийЦентр КАК МедЦентр,
	|	Запись.Номер КАК Номер,
	|	Запись.Сотрудник КАК Сотрудник,
	|	Запись.Услуга КАК Услуга
	|ИЗ
	|	Документ.Запись КАК Запись
	|ГДЕ
	|	Запись.Ссылка В(&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
    
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Тело = Макет.ПолучитьОбласть("Тело"); 
	
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		Шапка.Параметры.МедЦентр = Выборка.МедЦентр;
		ТабДок.Вывести(Шапка);
		
		Тело.Параметры.Клиент = Выборка.Клиент;
		Тело.Параметры.Месяц = Месяц(ТекущаяДата());
		Тело.Параметры.Год = Год(ТекущаяДата());
		Тело.Параметры.Число = "111111";
		ТабДок.Вывести(Тело);

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
КонецПроцедуры
#КонецОбласти