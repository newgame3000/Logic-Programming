# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Воронов К.М.
## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*

## Введение

Во время выполнения курсового проекта, я вспомнил, как программировать на bash, поднял навыки программирования на Prolog, а также потренировался в написании реферата.

## Задание

 1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM с использованием сервиса MyHeritage.com 
 2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog, используя следующее представление: `father(отец, потомок)` и `mother(мать, потомок)`
 3. Реализовать предикат проверки/поиска свекрови.  
 4. Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве
 5. [На оценки хорошо и отлично] Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы. 

## Получение родословного дерева

Я воспользовался родословным деревом М.А. Булгакова, в котором находятся 36 человек, вручную построив его на myheritage.com и преобразовав его в файл с расширением .ged.

## Конвертация родословного дерева

Для конвертации родословного дерева я воспользовался таким языком, как Bash, так как на нём очень удобно фильтровать текст и обрабатывать его. Для начала с помощью grep и sed я отфильтровал исходный текст на два файла: в одном из них были id людей с именами, а в другом id и члены семьи.
```
for str in `grep -Eo '(0 @.*@ INDI|1 NAME .* /.*/)' $1 | sed 's/0 @/@/g; s/@ INDI/@/g; s/1 NAME //g; s/\///g; s/ /_/g;'`; do
	echo $str >> text
done

for str in `grep -Eo '(0 @.*@ FAM|1 HUSB @.*@|1 WIFE @.*@|1 CHIL @.*@)' $1 | sed 's/0 @.*@ FAM//g; s/1 HUSB/HUSB/g; s/1 WIFE/WIFE/g; s/1 CHIL/CHIL/g;'`; do
	echo $str >> text2
done
```
Потом я с помощью ключей проходился по каждой семь, находил имена людей по id и записывал в 3 файл.

Также для реализации следующих заданий мне пришлось реализовать предикаты pol тем же самым методом.

## Предикат поиска родственника

Мой предикат поиска свекрови устроен следующим образом: Х является свекровью для Y, если X мать какого-то B, а Y его жена (есть общий ребёнок).

Реализация
```
:-include("predicats.pl").

svekrov(X,Y):-mother(X,B), father(B,C), mother(Y,C).
```
Примеры работы
```
?- svekrov(X,Y).
X = 'Maria_Miotiskaya',
Y = 'Varvara_Bulgakova' ;
X = 'Olimpiada_Ivanova',
Y = 'Varvara_Pokrovskaya' ;
X = 'Olimpiada_Ivanova',
Y = 'Varvara_Pokrovskaya' ;
X = 'Olimpiada_Ivanova',
Y = 'Varvara_Pokrovskaya' ;
X = 'Olimpiada_Ivanova',
Y = 'Varvara_Pokrovskaya' ;
X = 'Olimpiada_Ivanova',
Y = 'Varvara_Pokrovskaya' ;
X = 'Olimpiada_Ivanova',
Y = 'Varvara_Pokrovskaya' ;
X = 'Olimpiada_Ivanova',
Y = 'Varvara_Pokrovskaya' ;
X = 'Varvara_Pokrovskaya',
Y = 'Natalya_Minko' ;
false.
```

Из-за того, что Варвары Покровской много детей, Prolog много раз определяет Олимпиаду Иванову, как свекровь.

## Определение степени родства

Для определения степени родства я воспользовался поиском в глубину. Предикатaми переходов были мать, отец, сын, дочь, брат и сестра. Так как после поиска возвращался список имен, с помощью предиката to_relationship приходилось по второму разу проходится по этому списку и переделывать в степень родства. Таже приходится делать его реверс.

Реализация
```
:-include("predicats.pl").

brother(X,Y):- mother(Z,X), mother(Z,Y), pol(X,'M'), X \== Y,!.
sister(X,Y):- mother(Z,X), mother(Z,Y), pol(X,'F'), X \== Y,!.
daughter(X,Y):- mother(Y,X), pol(X,'F'),!.
daughter(X,Y):- father(Y,X), pol(X,'F'),!.
son(X,Y):- father(Y,X), pol(X,'M'),!. 
son(X,Y):- mother(Y,X), pol(X,'M'),!. 

move(X,Y):- mother(X,Y).
move(X,Y):- father(X,Y).
move(X,Y):- daughter(X,Y).
move(X,Y):- son(X,Y).
move(X,Y):- brother(X,Y).
move(X,Y):- sister(X,Y).

prolong([X|T], [Y,X|T]):- move(X,Y), not(member(Y,[X|T])).

to_relationship([_], []) :- !.

to_relationship([X, Y | T], ['daughter' | R]) :-
	daughter(Y, X),
	to_relationship([Y | T], R).

to_relationship([X, Y | T], ['son' | R]) :-
	son(Y,X),
	pol(Y,'M'),
	to_relationship([Y | T], R).

to_relationship([X, Y | T], ['mother' | R]) :-
	mother(Y, X),
	to_relationship([Y | T], R).

to_relationship([X, Y | T], ['father' | R]) :-
	father(Y, X),
	to_relationship([Y | T], R).

to_relationship([X, Y | T], ['brother' | R]) :-
	brother(Y, X),
	to_relationship([Y | T], R).

to_relationship([X, Y | T], ['sister' | R]) :-
	sister(Y, X),
	to_relationship([Y | T], R).

search([X | T], X, [X | T]).

search(X, Y, R) :-
	prolong(X, Z),
	search(Z, Y, R).

relative(R_E,X,Y):- search([X], Y, R), to_relationship(R,R2), reverse(R2,R_E).

```

Примеры работы
```
?- relative(X,'Ivan_Bulgakov','Mikhail_Bulgakov').X = [father, father, daughter, mother] ;
X = [father, father, brother, daughter, mother] ;
X = [father, father] ;
X = [father, father, daughter, mother] ;
X = [father, father, sister, daughter, mother] ;
X = [father, father, brother, daughter, mother] ;
X = [father, father, daughter, mother] ;
X = [father, father, sister, daughter, mother] ;
X = [father, father, daughter, mother] ;
X = [father, father, sister, daughter, mother] ;
false.


?- relative(X,'Andrey_Zemskiy','Nadegda_Bulgakova').
X = [father, daughter] ;
X = [father, sister, daughter] ;
X = [father, daughter] ;
X = [father, sister, daughter] ;
false.

```

## Естественно-языковый интерфейс

Для реализации естественно-языкового интерфейса я использовал словари. Потом я определил несколько структур предложений и с помощью append разбивал входящее и проверял принадлежность словарям. 
Я рассмотрел 3 сруктуры:


Составной вопрос how many, объект, вспомогательный глагол, имя, have.

Глагол to be, имя, объект, предлог, второе имя.

Вопрос, глагол to be, объект, предлог, имя.

Имя может быть записано местоимениями, если до этого упомянался человек. После парсинга предложения, с помощью предикатов rel и score я отвечал на поставленный вопрос.

Реализация
```
:-include("predicats.pl").

brother(X,Y):- mother(Z,X), mother(Z,Y), pol(X,'M'), X \== Y.
sister(X,Y):- mother(Z,X), mother(Z,Y), pol(X,'F'), X \== Y.
daughter(X,Y):- mother(Y,X), pol(X,'F').
daughter(X,Y):- father(Y,X), pol(X,'F').
son(X,Y):- father(Y,X), pol(X,'M'). 
son(X,Y):- mother(Y,X), pol(X,'M'). 


question_list(['How','many','Who']).
gl_list(['Is','is','are','Are']).
s_list(['mother','father','son','daughter','brother','sister','mothers','fathers','sons','daughters','brothers','sisters']).
o_list(['do','does','of']).
m_list(['he','she','him','her']).

name(NAME,J):-
m_list(M),
member(NAME,M), nb_getval('L_NAME', NAME).

name(NAME,NAME):-
m_list(M),
not(member(NAME,M)), nb_setval('L_NAME', J).


%% How many object does name have?
question(X,R):-

	question_list(Q),
	o_list(O),
	s_list(S),

	append([Q1|_],T,X),
	member(Q1,Q),
	append([Q2|_],T1,T),
	member(Q2,Q),
	append([OB|_],T2,T1),
	member(OB,S),
	append([DO|_],T3,T2),
	member(DO,O),
	append([NAME|_],T4,T3),
	name(NAME,N),
	T4 = ['have'|_],
	score(OB, N, R).

%% Is name object of name2?
question(X):-

	gl_list(Q),
	o_list(O),
	s_list(S),

	append([Q1|_],T,X),
	member(Q1,Q),
	append([NAME|_],T1,T),
	name(NAME,N1),
	append([OB|_],T2,T1),
	member(OB,S),
	append([DO|_],T3,T2),
	member(DO,O),
	append([NAME2|_],T4,T3),
	name(NAME2,N2),
	rel(OB,N1,N2).

%% Who is object of name?
question(X,R):-
	question_list(Q),
	gl_list(G),
	o_list(O),
	s_list(S),

	append([Q1|_],T,X),
	member(Q1,Q),
	append([H|_],T1,T),
	member(H,G),
	append([OB|_],T2,T1),
	member(OB,S),
	append([DO|_],T3,T2),
	member(DO,O),
	append([NAME|_],T4,T3),
	name(NAME,N),
	rel(OB,R,N).

rel('father',A,B):- father(A,B).
rel('mother',A,B):- mother(A,B).
rel('son',A,B):- son(A,B).
rel('sister',A,B):- sister(A,B).
rel('daughter',A,B):- daughter(A,B).
rel('brother',A,B):- brother(A,B).

score('mothers', NAME, 1).
score('fathers', NAME, 1).

score('sons', NAME, R):-
setof(X, son(X,NAME),RL),
length(RL,R).

score('daughters', NAME, R):-
setof(X, daughter(X,NAME),RL),
length(RL,R).

score('brothers', NAME, R):-
setof(X, brother(X,NAME),RL),
length(RL,R).

score('sisters', NAME, R):-
setof(X, sister(X,NAME),RL),
length(RL,R).

```

Примеры использования
```
?- question(['Is','Athanasiy_Bulgakov','father','of','Mikhail_Bulgakov','?']). 
true .

?- question(['How','many','sisters','does','Mikhail_Bulgakov','have','?'],R).
R = 4 .

?- question(['Who','is','brother','of','him','?'],R).
R = 'Ivan_Bulgakov_2' ;


```

## Выводы
Курсовой проект заставил меня затронуть такой язык, как Bash, который мне очень нравится. Написав на нём парсер, я вспомнил, как реализовывать решения для той или иной задачи. Также, реализовав четвёртое и пятое задания, я закрепил такие темы как грамматика и поиск на Prolog. Ещё я задумался о своей родословной, поспрашивал родных о своих прабабушках и прадедушках. Этот курсовой прект очень применим в жизни. С помощью реализованных программ можно провести целое исследование по своей родословной, сопоставить степень родства и даже позадовать вопросы! А это очень интересно.
