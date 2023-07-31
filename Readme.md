# Vivado
+ Работающий tb, необходимо корректировать работу модуля, проверить ошибки и добиться совпадения с Matlab'ом.
+ Попробовал перепроверить, думал всё исправлю тем что учту беззнаковость коэффициентов, но нет.
+ Вероятнее всего, неправильно понимаю дробную часть выхода из DSP48E2, а дальше уже и в остальном возникают несовпадения.

# Simulink
+ Добавил для проверки работы AGC, другой сигнал Wi-fi

# __Добавил QPSK__
+ Заменил функцию upfirdn, повысил частоту символов, сделал свёртку с импульсной характеристикой, компенсировал задержку фильтра.
+ Добавил графики сравнения с разным B, и корня и обычным.
	> Матлаб задержка <https://translated.turbopages.org/proxy_u/en-ru.ru.b2f2c020-6489def3-c2ac1bd7-74722d776562/https/www.mathworks.com/help/signal/ug/compensate-for-the-delay-introduced-by-an-fir-filter.html>

	> Матлаб SQRRC <https://www.mathworks.com/help/comm/ug/raised-cosine-filtering.html?searchHighlight=raised%20cosine&s_tid=srchtitle_raised%2520cosine_1>

	> Скляр <https://studizba.com/files/show/djvu/3087-1-sklyar-b-cifrovaya-svyaz-2003.html>

	> Фильтр Найквеста <https://zvondozvon.ru/radiosvyaz/filtr-najkvista> 

# __Добавил работающий умножитель__
+ Была ошибка в одном из сумматоров, считывание данных нужно всё ещё улучшить, пока что загружаю данные через import маталаба.
+ Сравнение было проведено по другому, данные которые подавались в формате int16 перевожу в double, и после этого умножаю их, полученный результат сравниваю с тем что в vivado, ошибка получилась равна нулю.

