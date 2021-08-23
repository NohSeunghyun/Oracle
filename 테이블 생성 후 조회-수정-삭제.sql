--테이블 생성 -> 데이터 추가 -> 데이터 조회/갱신/삭제

/*
테이블 이름 : client
열 자료형 : client_id(int), name(varchar/varchar2), gender(char), 
		 phone(varchar/varchar2), address(varchar/varchar2) 
*/

--테이블 생성

create table client(
client_id number(4) primary key,--중복X, 유일해야함(=유니크한값), Not Null
name varchar2(10) not null,--필수로 넣어야하는 부분이라면 not null표시.
gender char(1),
phone varchar2(14) not null,
address varchar2(50)
);

select *
from client;--생성 확인

/*
문제
client_id : 1
name : 홍길동 
gender : 남 -- 젠더의 바이트수를 1로 했기때문에 한글은 2~3바이트씩 차지하므로 영어인 M으로 표기
phone : 010-1111-1111
address : 대구 달서구 
*/

--데이터 추가

insert into client 
values (1,'홍길동','M','010-1111-1111','대구 달서구');
insert into client 
values (2,'안여진','F','010-2222-2222','대구 달서구');
insert into client 
values (3,'김진일','M','010-3333-3333','대구 달서구');

--client 테이블의 모든 정보 조회(=데이터 조회)

select *
from client;--입력 확인

--안여진의 주소를 '대구 달서구 이곡동'으로 변경(수정) 단,기본키를 기준으로 작성(=데이터 갱신)

update client 
set address='대구 달서구 이곡동'
where client_id=2;

select *
from client;--변경 확인

--김진일의 전화번호를 '010-3333-7777'으로 변경(수정) 단,기본키를 기준으로 작성(=데이터 갱신)

update client 
set phone='010-3333-7777'
where client_id=3;

select *
from client;--변경 확인

--'홍길동'관련정보를 삭제(=데이터 삭제하기)

delete from client
where client_id=1;

select *
from client;--삭제 확인

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--자동으로 client_id (primary key) 생성,증가하기.(=입력값을 넣을 때, client_id값을 안적어도 자동으로 생성,증가되게)12장-1.시퀀스 생성(교제 292p)

drop table client2;--테이블 삭제

create table client2(
client_id number(4) primary key,
name varchar2(10) not null,
gender char(1),
phone varchar2(14) not null,
address varchar2(50) not null
);

drop sequence client2_seq --시퀀스 삭제

create sequence client2_seq
start with 1000
increment by 1
minvalue 1000
maxvalue 9999
cycle;--시퀀스값이 최대값까지 증가 후 다시 start with값으로 돌아와서 다시 시작. 
--기본값:nocycle(최대값까지 증가 후 또 다시 시퀀스번호를 발급받으려 하면 에러발생.)

insert into client2 
values (client2_seq.nextval,'홍길동','M','010-1111-1111','대구 달서구');
insert into client2 
values (client2_seq.nextval,'안여진','F','010-2222-2222','대구 달서구');
insert into client2 
values (client2_seq.nextval,'김진일','M','010-3333-3333','대구 달서구');

select *
from client2;

/*
 * 문제
 * 테이블이름:client3
 * 열자료형:client_id(int=>number(4), name(varchar/varchar2(10)),
 * gender(char(1)),phone(varchar/varchar2(14)),address(varchar/varchar2(50))
 */

drop table client3;

--테이블생성
create table client3(
client_id number(4) primary key,
name varchar2(10) not null,
gender char(1),
phone varchar2(14) not null,
address varchar2(50) not null
);

select *
from client3;--생성 확인

/*
 * client3테이블에 데이터 삽입
 * client_id:1,         ,2
 * name:홍길동,          ,이순신
 * gender:M,            ,M
 * phone:010-1111-1111  ,010-2222-2222
 * address:대구 달서구         ,대구 북구
 */

drop sequence client3_seq;

create sequence client3_seq
start with 1
increment by 1
maxvalue 9999
minvalue 1
cycle;

--데이터삽입
insert into client3 
values (client3_seq.nextval,'홍길동','M','010-1111-1111','대구 달서구');
insert into client3 
values (client3_seq.nextval,'이순신','M','010-2222-2222','대구 북구');
insert into client3 
values (client3_seq.nextval,'노승현','M','010-3333-3333','대구');

select *
from client3;--삽입 확인

--'이순신'의 주소를 '대구 북구 복현동'으로 변경(기본키를 기준으로)

update client3 
set address='대구 북구 복현동'
where client_id=2;

select *
from client3;--변경 확인

--'이순신'의 데이터를 삭제하세요.(기본키를 기준으로)

delete from client3
where client_id=2;

select *
from client3;--삭제확인

/************************************************************************************************************************************/