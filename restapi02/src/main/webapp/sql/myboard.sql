-- 스프링 게시판
select * from tab;
select * from seq;
select * from myboard;

--테이블명 :  myboard
create table myboard(
	  no number primary key,
	  writer varchar2(20),
      passwd varchar2(20),
	  subject varchar2(50),
	  content varchar2(100),
	  readcount number,
	  register date );

--시퀀스 : myboard_seq
create sequence myboard_seq
start with 1
increment by 1
nocache;