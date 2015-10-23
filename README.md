# Планируемый срок
    - Парсер (1.5 часа)
    - Сохранение в БД (0.5) часа
    - Сделать табличку в UI с отображением собранных данных + фильтр (0.5 нарисовать + 0.5 часа подключить Elasticsearch для полнотекстового поиска)
    - Фоновое выполнение сбора данных - 0.5 часа
    - Деплой скрипт на сервер и задеплоить результат на какой-нибудь сервер (0.5 часа деплой + 1 час настройка сервера)
    - Полнотекстовый поиск по собранным данным - 1 час
    - Сбор данных по расписанию - раз в сутки в 2:00 по Москве - 0.5 часа
    - Нормализация названия города к единому формату (как в КЛАДР) - хз
    
### Итого 6.5 часов + хз :)

# Итоговый результат
    - Парсер    (1 час + 20 минут правки + 1 правки метода get_html (замена curl на Net::HTTP))
    - Сохранение в БД ( 50 минут )
    - Сделать табличку в UI с отображением собранных данных + фильтр (20 минут + 20 минут + 10 минут добавления очистки и связанного с этим функционала)
    - Фоновое выполнение сбора данных (10 минут)
    - Деплой скрипт на сервер и задеплоить результат на какой-нибудь сервер (1 час 30 минут)
    - Полнотекстовый поиск по собранным данным - (40 минут серверная часть)
    - Сбор данных по расписанию - раз в сутки в 2:00 по Москве (10 минут)
    - Нормализация названия города к единому формату (как в КЛАДР) (не делал)

### Итого - 6 часов 30 минут