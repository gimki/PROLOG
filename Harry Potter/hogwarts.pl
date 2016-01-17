% the students in Hogwarts
student(hp, 'Harry James Potter', gryffindor).
student(hg, 'Hermione Jean Granger', gryffindor).
student(rw, 'Ronald Weasley', gryffindor).
student(ll, 'Luna Lovegood', ravenclaw).
student(cc, 'Cho Chang', ravenclaw).
student(tb, 'Terry Boot', ravenclaw).
student(ha, 'Hannah Abbott', hufflepuff).
student(cd, 'Cedric Diggory', hufflepuff).
student(nt, 'Nymphadora Tonks',hufflepuff).
student(dm, 'Draco Malfoy', slytherin).
student(gg, 'Gregory Goyle', slytherin).
student(vc, 'Vincent Crabbe', slytherin).

% the teachers in Hogwarts
teacher(ad, 'Albus Percival Wulfric Brian Dumbledore').
teacher(ff, 'Filius Flitwick').
teacher(rh, 'Rubeus Hagrid').
teacher(gl, 'Gilderoy Lockhart').
teacher(rl, 'Remus John Lupin').
teacher(mm, 'Minerva McGonagall').
teacher(qq, 'Quirinus Quirrell').
teacher(ss, 'Severus Snape').
teacher(ps, 'Pomona Sprout').
teacher(st, 'Sibyll Patricia Trelawney').
teacher(mh, 'Madam Hooch').
teacher(as, 'Aurora Sinistra').
teacher(cub, 'Cuthbert Binns').
teacher(bb, 'Bathsheba Babbling').
teacher(sv, 'Septima Vector').
teacher(chb, 'Charity Burbage').
teacher(wt, 'Wilkie Twycross').

% compulsory courses for the MSc in Magic
compCourse(astro, 'Astronomy', as).
compCourse(charms, 'Charms', ff).
compCourse(defence, 'Defence against the Dark Arts', qq).
compCourse(fly, 'Flying', mh).
compCourse(herb, 'Herbology', ps).
compCourse(history, 'History of Magic', cub).
compCourse(potions, 'Potions', ss).
compCourse(trans, 'Transfiguration', mm).

% optional courses for the MSc in Magic
optCourse(runes, 'Study of Ancient Runes', bb).
optCourse(arith, 'Arithmancy', sv).
optCourse(muggle, 'Muggle Studies', chb).
optCourse(creatures, 'Care of Magical Creatures', rh).
optCourse(div, 'Divination', st).
optCourse(app, 'Apparition', wt).
optCourse(choir, 'Frog Choir', ff).
optCourse(quid, 'Quidditch', mh).

%%%%%%%%%%%%%%%%%%%%%%%
%Question 1
student(cy, 'Colman Yau', gryffindor).

%Question 2
enrolled_opt(hp,runes).
enrolled_opt(hp,arith).
enrolled_opt(hp,muggle).
%6 for hg
enrolled_opt(hg,creatures).
enrolled_opt(hg,div).
enrolled_opt(hg,app).
enrolled_opt(hg,choir).
enrolled_opt(hg,quid).
enrolled_opt(hg,runes).
%
enrolled_opt(rw,arith).
enrolled_opt(rw,muggle).
enrolled_opt(rw,creatures).
%
enrolled_opt(ll,div).
enrolled_opt(ll,app).
enrolled_opt(ll,choir).
%
enrolled_opt(cc, quid).
enrolled_opt(cc,runes).
enrolled_opt(cc, arith).
%
enrolled_opt(tb,creatures).
enrolled_opt(tb,runes).
enrolled_opt(tb, quid).
%
enrolled_opt(ha,creatures).
enrolled_opt(ha,div).
enrolled_opt(ha,arith).
%
enrolled_opt(cd, quid).
enrolled_opt(cd,app).
enrolled_opt(cd,muggle).
%
enrolled_opt(nt,creatures).
enrolled_opt(nt,div).
enrolled_opt(nt,choir).
%
enrolled_opt(dm,runes).
enrolled_opt(dm, quid).
enrolled_opt(dm,app).
%
enrolled_opt(gg,creatures).
enrolled_opt(gg,runes).
enrolled_opt(gg,div).
%
enrolled_opt(vc,runes).
enrolled_opt(vc, quid).
enrolled_opt(vc,app).
%
enrolled_opt(cy,runes).
enrolled_opt(cy,arith).
enrolled_opt(cy,muggle).

%Question 3
%Student with SID is enrolled on course with short name SCN (compulsort+optional)
enrolled(SID,SCN):-compCourse(SCN,_,_),student(SID,_,_).
enrolled(SID,SCN):-enrolled_opt(SID,SCN).

%Question 4
%witch with TN teaches course with short name SCN
teaches(TN,SCN):- teacher(TID,TN),compCourse(SCN,_,TID).
teaches(TN,SCN):- teacher(TID,TN),optCourse(SCN,_,TID).

%Question 5
%Student SN enrolled on a magical course which is taught by TN
taughtBy(SN,TN):-student(SID,SN,_),enrolled(SID,SCN),teaches(TN,SCN).

%Question 6
%Student SN is enrolled on the optional course called CN.
takesOption(SN,CN):-student(SID,SN,_),enrolled_opt(SID,SCN),optCourse(SCN,CN,_).

%Question 7
%Optcourse is a list of all optional course taken by SN. The list is in alphabetical order.
takesAllOptions(SN,OptCourses):-setof(CN,takesOption(SN,CN),OptCourses).

%Question 8
%House is a particular house; Student is a list of all Student name belonging to particular house.
%
studentsInHouse(House,Students):-house(House),(setof((SID),N^student(SID,N,House),X)->findall(SN,(member(K,X),student(K,SN,_)),Students);Students =[]).

%Question 9
studentsOnCourse(SCN,CN,StudentsByHouse):-sameCourses(SCN,CN),StudentsByHouse=[gryffindor-GL,hufflepuff-HL,ravenclaw-RL,slytherin-SL],findall(SN,(enrolled(SID,SCN),student(SID,SN,gryffindor)),GL),findall(SN,(enrolled(SID,SCN),student(SID,SN,ravenclaw)),RL),findall(SN,(enrolled(SID,SCN),student(SID,SN,hufflepuff)),HL),findall(SN,(enrolled(SID,SCN),student(SID,SN,slytherin)),SL).

%Question 10
%optional course with name CN is taken by two different students with names SN1 and SN2 students.
sharedCourse(SN1, SN2, CN):- takesOption(SN1,CN),takesOption(SN2,CN),SN1\=SN2.

%Question 11
%Two different students enrolled on exactly the same three optional courses, which form the list Courses of the course names
%(order does not matter). Hermione just need to match 3 optional courses with others out of her 6.
sameOptions(SN1,SN2,List):-length(List,3),bagof(CN,sharedCourse(SN1,SN2,CN),List).




%Helper function
house(gryffindor).
house(ravenclaw).
house(hufflepuff).
house(slytherin).
%sameCourses(SCN,CN) can verify whether SCN matches with CN (or unify SCN/CN given the corresponding CN/SCN).
sameCourses(SCN,CN):-compCourse(SCN,CN,_);optCourse(SCN,CN,_).




