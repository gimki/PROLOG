sentence(S):- noun_phrase(NP), verb_phrase(VP), append(NP, VP, S).


noun_phrase(NP):- article(A), noun(N), append(A, N, NP).

verb_phrase(V):- verb(V).
verb_phrase(VP):- verb(V), noun_phrase(NP), append(V, NP, VP).

% The Lexicon:

article([the]).
article([a]).
article([an]).

noun([grass]).
noun([cow]).
noun([girl]).
noun([boy]).
noun([apple]).
noun([song]).

verb([eats]).
verb([sings]).
verb([chews]).
verb([kicks]).


adverb([slowly]).
adverb([deliberately]).
adverb([merrily]).
adverb([sweetly]).

%Question 1a
% Using recursion to match the sentence(s) from the text from the left

%base case: where the text only contain a sentence
count_sentences([A,B,C],1):-sentence([A,B,C]).
count_sentences([A,B,C,D,E],1):-sentence([A,B,C,D,E]).
%recursive cases where matching the sentence + and and add 1 to the count and recursively apply count_sentences to the tail
count_sentences([A,B,C,and|T],Count):-sentence([A,B,C]),count_sentences(T,Cl),Count is Cl+1.
count_sentences([A,B,C,D,E,and|T],Count):-sentence([A,B,C]),count_sentences(T,Cl),Count is Cl+1.


%Question 1b
%make use of the helper function followedBy, to extract the word after the actor and check whether it is a verb and add to a set if condition satisfied
followedBy(X,Y,L) :- append(_,[X,Y|_],L).
actions(Actor,Text,As):-noun([Actor]),setof(Y, (verb([Y]),followedBy(Actor,Y,Text)),As).

%Question 2
%make use of the vowel functino to check whether a given character a vowel or not
%if the article is "the", we just need to check whether the latter word is a noun or not
noun_phrase_better(NP):-article(A), noun(N), append(A, N, NP),A==[the].

%if it is "an", we will need to check whether the word starts with a vowel or not
noun_phrase_better(NP):-article(A), noun(N), append(A, N, NP),A==[an],member(Ni,N),atom_chars(Ni,L),L=[H|_],vowel(H).

%if it is "a", we will need to check whether the word starts with a non-vowel or not
noun_phrase_better(NP):-article(A), noun(N), append(A, N, NP),A==[a],member(Ni,N),atom_chars(Ni,L),L=[H|_],\+vowel(H).
vowel(A):-A==a;A==e;A==i;A==o;A==u.

%Question 3a
%This session will create cadvs; verb_phrase_better and sentence_better.

%Question 3b
%make use of the accumulator
cadvs(Text):-accum(Text,[]).

%it is always true if there is only an adverb
accum(A,[]):-adverb(A).

%recursive case which take in all but the final two adverb joining by the ','.
accum([A,','|T],L):- adverb([A]),\+member(A,L),L1=[A|L],accum(T,L1).

%base case which verify the last two adverbs joint by "and"
accum([A,and,B],L):- adverb([A]),adverb([B]),\+(A==B),\+member(A,L),\+member(B,L).


%Question 3c

%Case 1: a verb
verb_phrase_better(V):-verb(V).

%Case 2: a verb followed by a better noun phrase
verb_phrase_better(VP):-verb(V),noun_phrase_better(NP),append(V,NP,VP).

%Case 3: a conjunctions of adverbs followed by a verb
verb_phrase_better(VP):-verb(V),cadvs(T),append(T,V,VP).

%Case 4: a conjunctions of adverbs followed by a verb, followed by a better noun phrase
verb_phrase_better(VP):-verb(V),cadvs(T),noun_phrase_better(NP),append(T,V,VP1),append(VP1,NP,VP).

%Question 3d
%better sentence in better noun phrase and followed by a better verb phrase
sentence_better(Text):-noun_phrase_better(NP),verb_phrase_better(VP),append(NP,VP,Text).











