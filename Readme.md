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
