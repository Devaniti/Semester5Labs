age(N,'Nemovla'):- (2017-N)=<1.
age(N,'Dytyna'):- (2017-N)>1,(2017-N)=<11.
age(N,'Pidlitok'):- (2017-N)>11,(2017-N)=<15.
age(N,'Yunak'):- (2017-N)>15,(2017-N)=<21.
age(N,'Cholovik'):- (2017-N)>21,(2017-N)=<65.
age(N,'Stariy'):- (2017-N)>65,(2017-N)=<90.
age(N,'Dovgoshitel'):- (2017-N)>90.

age1(N,'Nemovla'):- (2017-N)=<3,!.
age1(N,'Dytyna'):- (2017-N)=<12,!.
age1(N,'Pidlitok'):- (2017-N)=<15,!.
age1(N,'Yunak'):- (2017-N)=<26,!.
age1(N,'Cholovik'):- (2017-N)=<70,!.
age1(N,'Stariy'):- (2017-N)=<95,!.
age1(N,'Dovgoshitel'):- (2017-N)>95.
