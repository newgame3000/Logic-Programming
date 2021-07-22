#№ Отчет по лабораторной работе №3
## по курсу "Логическое программирование"

## Решение задач методом поиска в пространстве состояний

### студент: Воронов К.М.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |    5-         |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

Задачи, в которых можно перебрать все варианты состояний, очень удобно решаются методом поиска в пространстве состояний. Скорость решения таких задач будет зависеть от количества этих состояний и последовательности поиска. Пролог оказывается удобным для реализации поисков и соответственно для решения таких головоломок. Иногда перебрать все варианты решений не так долго, как кажется, и намного быстрее, чем решать эту задачу самому.

## Задание

6. Вдоль доски расположено  8  лунок, в которых лежат  4  черных и  3  белых шара. Передвинуть черные шары на место белых, а белые - на место черных. Шар можно передвинуть в соседнюю с ним пустую лунку, либо в пустую лунку, находящуюся непосредственно за ближайшим шаром. При этом черные шары можно передвигать только вправо, а белые - только влево. 

## Принцип решения

Для начала я записал все правила передвижения шаров, описав их в ситуациях с тремя местами.

```Prolog 
go([b,e,w],X):- X=[b,w,e]; X=[e,b,w].

go([b,e,b],X):- X=[e,b,b].
go([b,b,e],X):- X=[b,e,b].
go([w,b,e],X):- X=[w,e,b].

go([w,e,w],X):- X=[w,w,e].
go([e,w,w],X):- X=[w,e,w].
go([e,w,b],X):- X=[w,e,b].

go([b,w,e],X):- X=[e,w,b].
go([e,b,w],X):- X=[w,b,e].
```
Далее я написал предикат move, который меняет состояние этой системы. Он работает следующим образом: с помощью append мы делим наш изначальный список на 2, пытаемся применить одно из правил описанных выше и соединяем обратно другими append.

```Prolog
move(At,To):- append(X,[A,B,C|T],At), go([A,B,C],G), append(X,G,H), append(H,T,To).
```
Теперь я приступаю к непосредственному поиску, используя move. Предикат prolonged "проделывает путь", то есть совершает смену состояние и проверяет, что такого состояние не было раньше, чтобы не происходило зацикливание.

```Prolog
prolong([X|T],[Y,X|T]):- move(X,Y), not(member(Y,[X|T])).
```

Далее напишем предикат path, который будет включать в себя начальное состояние Х, конечное состояние Y и путь P. Он будет запускать предикат bdth, поиск в ширину, основанный на очереди, где первый аргумент является списком списков, а второй и третий остаются теми же. Далее опишем конец этого поиска, когда мы достигли конечного состояния. Потом же мы описываем непосредственно шаг поиска, то есть берём первый элемент в очереди, продляем его и помещаем в конец очереди. И если у нас появился непродляемый путь, то мы удаляем его из очереди и продолжаем поиск с хвоста очереди. Чтобы ответ было лучше видно, я вывожу во время поиска путь P с помощью write.

```Prolog
path(X,Y,P):- bdth([[X]],Y,P),write(P).

bdth([[X|T]|_],X,[X|T]).
bdth([P|QI],X,R):- findall(Z,prolong(P,Z),T),
                   append(T,QI,QO),!,
                   bdth(QO,X,R).

bdth([_|T],Y,L):- bdth(T,Y,L).
```

Этот поиск очень легко превратить в поиск в глубину. Нам нужно всего лишь поменять местами в append T и QI, тем самым добавлять вновь полученые пути не в конец очереди, а в начало очереди. Получается мы взяли текущий путь, продлили и сразу в начало очереди его положили. И мы получим практически поиск в глубину.

Также создадим новый поиск: поиск в глубину с ограничением этой самой глубины. Предикат search_id получит новый параметр ограничения N. С помощью предиката int будем делать перебор по длине кратчайшего пути, а предиката depth_id - продолжать поиск. 

```Prolog
search_id(X,Y,P) :- int(N), search_id(X, Y, P, N), !,write(P).
search_id(X,Y,P,N) :- depth_id([X], Y, P, N).

int(1).
int(N) :- int(M), N is M+1.

depth_id([X|T],X,[X|T], _).
depth_id(X,Y,P,N) :- N>0, prolong(X, XX), N1 is N-1, depth_id(XX, Y, P, N1).

```

Предикаты time_bdth и time_search_id будут считать время поиска.

```Prolog
time_bdth(X,Y,Time):- get_time(Start), search_id(X,Y,P), get_time(End), Time is End - Start.
time_search_id(X,Y,Time):- get_time(Start), path(X,Y,P), get_time(End), Time is End - Start.
```

## Результаты

Приведите результаты работы программы: найденные пути, время, затраченное на поиск тем или иным алгоритмом, длину найденного первым пути. Используйте таблицы, если необходимо.

```Prolog
?- path([b,b,b,b,e,w,w,w],[w,w,w,e,b,b,b,b],X).
[[w,w,w,e,b,b,b,b],[w,w,e,w,b,b,b,b],[w,w,b,w,e,b,b,b],[w,w,b,w,b,e,b,b],[w,w,b,e,b,w,b,b],[w,e,b,w,b,w,b,b],[e,w,b,w,b,w,b,b],[b,w,e,w,b,w,b,b],[b,w,b,w,e,w,b,b],[b,w,b,w,b,w,e,b],[b,w,b,w,b,w,b,e],[b,w,b,w,b,e,b,w],[b,w,b,e,b,w,b,w],[b,e,b,w,b,w,b,w],[b,b,e,w,b,w,b,w],[b,b,b,w,e,w,b,w],[b,b,b,w,b,w,e,w],[b,b,b,w,b,e,w,w],[b,b,b,e,b,w,w,w],[b,b,b,b,e,w,w,w]]
X = [[w, w, w, e, b, b, b, b], [w, w, e, w, b, b, b|...], [w, w, b, w, e, b|...], [w, w, b, w, b|...], [w, w, b, e|...], [w, e, b|...], [e, w|...], [b|...], [...|...]|...] .

?- search_id([b,b,b,b,e,w,w,w],[w,w,w,e,b,b,b,b],X).
[[w,w,w,e,b,b,b,b],[w,w,e,w,b,b,b,b],[w,w,b,w,e,b,b,b],[w,w,b,w,b,e,b,b],[w,w,b,e,b,w,b,b],[w,e,b,w,b,w,b,b],[e,w,b,w,b,w,b,b],[b,w,e,w,b,w,b,b],[b,w,b,w,e,w,b,b],[b,w,b,w,b,w,e,b],[b,w,b,w,b,w,b,e],[b,w,b,w,b,e,b,w],[b,w,b,e,b,w,b,w],[b,e,b,w,b,w,b,w],[b,b,e,w,b,w,b,w],[b,b,b,w,e,w,b,w],[b,b,b,w,b,w,e,w],[b,b,b,w,b,e,w,w],[b,b,b,e,b,w,w,w],[b,b,b,b,e,w,w,w]]
X = [[w, w, w, e, b, b, b, b], [w, w, e, w, b, b, b|...], [w, w, b, w, e, b|...], [w, w, b, w, b|...], [w, w, b, e|...], [w, e, b|...], [e, w|...], [b|...], [...|...]|...].
```

| Алгоритм поиска |  Длина найденного первым пути  |  Время работы  |
|-----------------|--------------------------------|----------------|
| В глубину       |               20               |     0.0823     |
| В ширину        |               20               |     0.0995     |
| ID              |               20               |     0.0517     |

## Выводы

Данная лабораторная работа научила меня писать поиски на Прологе и решать некоторые головоломки. Также я задумался над тем, как искусственный интеллект анализирует и находит правильные ответы в тех или иных задачах, фактически он делает перебор вариантов заданным алгоритмом. В моей программе самым оптимальным оказался алгоритм поиска в глубину с ограничением, на втором месте обычный в глубину, а на третьем в ширину. Но в других случаях ситуация могла выглядеть иначе, всё зависит от того, каким образом можно добраться от начального состояния к конечному, всё зависит от конкретного графа. 



