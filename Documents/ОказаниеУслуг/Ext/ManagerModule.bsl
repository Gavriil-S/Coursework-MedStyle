﻿
Процедура Печать(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Печать)
	Макет = Документы.ОказаниеУслуг.ПолучитьМакет("Печать");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОказаниеУслуг.Дата,
	|	ОказаниеУслуг.Клиент,
	|	ОказаниеУслуг.Номер,
	|	ОказаниеУслуг.Организация,
	|	ОказаниеУслуг.СуммаПоДокументу,
	|	ОказаниеУслуг.Услуги.(
	|		НомерСтроки,
	|		Наименование,
	|		Цена,
	|		Количество,
	|		Сумма
	|	)
	|ИЗ
	|	Документ.ОказаниеУслуг КАК ОказаниеУслуг
	|ГДЕ
	|	ОказаниеУслуг.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьУслугиШапка = Макет.ПолучитьОбласть("УслугиШапка");
	ОбластьУслуги = Макет.ПолучитьОбласть("Услуги");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		ТабДок.Вывести(ОбластьУслугиШапка);
		ВыборкаУслуги = Выборка.Услуги.Выбрать();
		Пока ВыборкаУслуги.Следующий() Цикл
			ОбластьУслуги.Параметры.Заполнить(ВыборкаУслуги);
			ТабДок.Вывести(ОбластьУслуги, ВыборкаУслуги.Уровень());
		КонецЦикла;

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры
