# __QPSK__
+ Заменил функцию upfirdn, повысил частоту символов, сделал свёртку с импульсной характеристикой, компенсировал задержку фильтра.
+ Добавил графики сравнения с разным B, и корня и обычным.
	> Матлаб задержка <https://translated.turbopages.org/proxy_u/en-ru.ru.b2f2c020-6489def3-c2ac1bd7-74722d776562/https/www.mathworks.com/help/signal/ug/compensate-for-the-delay-introduced-by-an-fir-filter.html>

	> Матлаб SQRRC <https://www.mathworks.com/help/comm/ug/raised-cosine-filtering.html?searchHighlight=raised%20cosine&s_tid=srchtitle_raised%2520cosine_1>

	> Скляр <https://studizba.com/files/show/djvu/3087-1-sklyar-b-cifrovaya-svyaz-2003.html>

	> Фильтр Найквеста <https://zvondozvon.ru/radiosvyaz/filtr-najkvista> 

# __Добавил EMA, на одном дсп элементе__
+ Размерности пока ещё не расматривал
+ Задержки не уверен, что верные
+ Необходимо проверить алгоритм в Testbench, и сверить с моделью в Matlab'e 

# __Добавил QPSK__

+ В QPSK_example.m продемонстрировано создание модулированного сигнала
+ *Вопрос в создании SQRRC*
	> Параметр span из документации, сейчас выбрал равным 100, так как в описании сказано количество символов.
	
		span            = 100

+ *Вопрос в частоте дискретизации*
	> Пока как понял я выбираю количество битов-сиволов, далее через sps, оно увелчивается в 4 раза, создаю для каждого значения амплитуды фиксированное количество точек, как сюда внедрить понятие дискретизации сигнала не ясно.
+ Чтобы запустить в симулинке, достаточно прогнать секцию Parameters, а потом либо Sine, либо QPSK.

		%% Parameters
		%% Sine wave or %% QPSK - signal
# __Добавил работающий умножитель__
+ Была ошибка в одном из сумматоров, считывание данных нужно всё ещё улучшить, пока что загружаю данные через import маталаба.
+ Сравнение было проведено по другому, данные которые подавались в формате int16 перевожу в double, и после этого умножаю их, полученный результат сравниваю с тем что в vivado, ошибка получилась равна нулю.

