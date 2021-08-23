--<북스-8장. 테이블 생성, 수정, 제거하기>
--데이터 정의어 (DDL=Data Definition Language)
--1.CREATE : DB 객체 생성
--2.ALTER : DB 객체 변경
--3.DROP : DB 객체 제거 (=삭제)
--4.RENAME : DB 객체 이름 변경
--5.TRUNCATE : 데이터 및 저장 공간 삭제

---------------------------------------------------------------------------------------------------------------------------------------
--1. 테이블 구조를 만드는 CREATE TABLE 문
--테이블 생성하기 위해서는 테이블명 정의, 테이블을 구성하는 컬럼의 데이터 타입과 무결성 제약 조건 정의

--<테이블명 및 컬럼명 정의 규칙>
--문자 (영어 대소문자)로 시작, 30자 이내
--문자 (영어 대소문자), 숫자 0~9, 특수문자 : _ $ # 세가지만 사용가능
--대소문자 구별없음, 소문자로 저장하려면 ''로 묶어줘야함
--동일 사용자의 다른 객체의 이름과 중복X 예)SYSTEM이 만든 테이블명들은 다 달라야 함.

--<서브쿼리를 이용하여 다른 테이블로부터 테이블 생성 방법>
--서브쿼리문으로 부서테이블의 구조와 데이터 복사->새로운 테이블 생성
--create table 테이블명 (컬럼명 명시O)(=명시 했을 때) : 지정한 컬럼수와 데이터 타입이 서브쿼리문의 검색된 컬럼과 일치해야함.
--create table 테이블명 (컬럼명 명시X)(=명시 안했을 때) : 서브쿼리의 컬럼명이 그대로 복사됨.

--★★복사 시 무결성 제약조건 : not NULL 조건만 복사,
--						기본키(=PK), 외래키(=FK)와 같은 무결성제약조건은 복사X
--						디폴트 옵션에서 정의한 값은 복사

--서브쿼리의 출력결과가 테이블의 초기데이터로 삽입됨.

--예)create table 테이블명(컬럼명 명시O)
--문제. 서브쿼리문으로 부서테이블의 구조와 데이터 복사하기
select dno from department;--컬럼수 1개

create table dept1(dept_id)--컬럼수 1개
as 
select dno--컬럼수  1개
from department;--as 뒤의 실행문이 서브쿼리.()없다고 서브쿼리가 아닌게 아니다.

select dept_id from dept1;--복사 확인

--예)create table 테이블명 (컬럼명 명시X)
--문제. 20번 부서 소속 사원에 대한 정보(사원번호, 이름, 연봉)를 포함한 dept20테이블 생성하기
--[1]. 20번 부서 소속 사원에 대한 정보(사원번호, 이름, 연봉) 조회
select eno, ename, salary*12 as "연봉"
from employee
where dno=20;

create table dept2
as
select eno, ename, salary*12 -- ★★별칭 사용 안할 시 오류
from employee
where dno=20;

create table dept2
as
select eno, ename, salary*12 as "연봉" -- ★★이유? 서브쿼리문 내에 산술식에 대해 별칭을 반드시 지정해야함.
from employee
where dno=20;

select * from dept2;--복사 확인
 
--<서브쿼리의 데이터는 복사하지 않고 테이블 구조만 복사하는 방법>
--서브쿼리의 where절을 항상 거짓이 되는 조건 지정 : 조건에 맞는 데이터가 없어서 데이터 복사안됨.
--where 0=1

--문제. 부서 테이블의 구조만 복사하여 dept3테이블 생성
create table dept3
as
select *
from department
where 0=1;

select * from dept3;--구조만 복사되고 데이터는 복사되지 않음.

desc dept3;--테이블 구조 확인(이클립스에서는 명령어가 실행안됨)
--RUN SQL....실행 -> CONN SYSTEM/1234 -> desc dept3; 

---------------------------------------------------------------------------------------------------------------------------------------
--2. 테이블 구조를 변경하는 ALTER TABLE 문
--2-1. 컬럼 추가 : 추가된 컬럼은 마지막 위치에 생성(즉, 원하는 위치를 지정할 수 없음)

--문제. dept2테이블에 날짜 타입을 가진 birth 컬럼을 추가
alter table dept2
add (birth date);

--이 테이블에 기존에 추가한 데이터(행)가 있으면 추가한 컬럼의 컬럼값은 NULL로 자동 입력됨.

--RUN SQL로 타입 및 크기 확인
desc dept2;
--일반적인 방법으로 삭제 확인.(타입, 크기를 확인하는 것이 아니기때문에 RUN SQL 사용안해도됨)
select * from dept2;

--2-2. 컬럼 변경
--기존 컬럼에 데이터가 없는 경우 : 컬럼타입이나 크기 변경이 자유롭다.
--				  있는 경우 : 타입변경은 char와 varchar2만 허용하고
--						    문자타입은 변경할 컬럼의 크기가 저장된 데이터의 크기보다 같거나 클 경우에만 변경가능
--						    숫자타입은 폭 또는 전체자릿수 늘릴 수 있다.예)number(7),number(7.2)--전체7자리수.소수둘째자리까지 허용

--문제. 사원이름의 컬럼크기를 변경 10->30
--타입 확인은 RUN SQL....을 실행하여 확인하는게 편한거 같다
--RUN SQL로 타입 및 크기 확인
desc dept2;

alter table dept2
modify ename varchar2(30);--컬럼 크기가 10->30으로 변경

--RUN SQL로 변경한 타입 및 크기 학인
desc dept2;

--사원이름의 타입을 변경 varchar2->char
alter table dept2
modify ename char(30);

--RUN SQL로 변경한 타입 및 크기 학인
desc dept2;

--사원이름의 컬럼크기를 변경 30->10
alter table dept2
modify ename char(10);--오류:크기를 작게 변경 불가.
--크기 30->40
alter table dept2
modify ename char(40);

--RUN SQL로 변경한 타입 및 크기 학인
desc dept2;

--사원이름의 타입 및 크기 변경
alter table dept2
modify ename number(30);--오류:타입변경은 char와 varchar2만 허용하기때문에 다른 타입으로 변경불가.

--다시 크기 원상복구 : 크기를 맨처음 상태인 varchar2(10)으로 변경 불가하기 때문에 타입만 char->varchar2로 바꾸고 크기를 현재 크기인 40으로 한다.
alter table dept2
modify ename varchar2(40);

--RUN SQL로 변경한 타입 및 크기 학인
desc dept2;

--drop, unused : 둘다 실행한 후 되돌릴 수 없음.
--2-3. 컬럼 제거 : 2개 이상 컬럼이 존재한 테이블에서만 컬럼 삭제 가능
--문제. dept2테이블에서 사원이름 제거
alter table dept2
drop column ename;

--RUN SQL로 변경한 타입 및 크기 학인
desc dept2;
--일반적인 방법으로 삭제 확인.(타입, 크기를 확인하는 것이 아니기때문에 RUN SQL 사용안해도됨)
select * from dept2;

--2-4. set unused : 시스템의 요구가 적을때 컬럼을 제거할 수 있도록 하나이상의 컬럼을 unused로 표시
--사용하지 않는 컬럼을 숨김. 사용,조회 못하게 막음 (컬럼 제거와 다름.)
--실제로 제거되지는 않음 -> drop명령 실행으로 컬럼을 제거하는 것보다 응답시간이 빨라짐
--데이터가 존재하는 경우에는 삭제된 것처럼 처리되기 때문에 select절로 조회불가
--사용하는 이유 : 1. 사용자에게 보이지 않게 하기 위해
--			  2. 즉시(자주) 사용되지 않는 컬럼은 drop으로 제거를 할 수 있다. 
--				  						 unused로 미사용 상태로 표시한 후 나중에 한꺼번에 drop으로 제거하기 위해
--설명쉽게풀이=운영 중에 컬럼을 삭제(drop)하는 것은 시간이 오래 걸릴수 있어서 unused로 표시해두고 한꺼번에 삭제(drop)
--desc(=describe 문으로도 표시되지 않음(RUN SQL....로 실행하는 명령어)) 예)desc 테이블명; 테이블 구조 확인

--문제. dept2테이블에서 사원번호를 unused상태로 만들기
alter table dept2
set unused (eno);

--RUN SQL로 변경한 타입 및 크기 학인(RUN SQL에도 안보임)
desc dept2;
--일반적인 방법으로 삭제 확인.(타입, 크기를 확인하는 것이 아니기때문에 RUN SQL 사용안해도됨)
select * from dept2;

--eno는 PK이기때문에 사용안하게하면 안됨.그래서 다른걸로 바꾼다.(되돌린 후 함.177번째 줄)

--이미 unused한것을 되돌리는 방법 : 한번 unused된 것은 되돌릴수 없기때문에 drop으로 테이블 삭제하고 다시 만듦
drop table dept2;

create table dept2
as
select eno, ename, salary*12 as "연봉"
from employee
where dno=20;

alter table dept2
add (birth date);

alter table dept2
modify ename varchar2(40);

--eno는 PK이기때문에 다른걸 unused -> "연봉" 별칭으로도 되는지 해보기
alter table dept2
set unused ("연봉");--별칭으로도 가능.

--RUN SQL로 변경한 타입 및 크기 학인(RUN SQL에도 안보임)
desc dept2;
--일반적인 방법으로 삭제 확인.(타입, 크기를 확인하는 것이 아니기때문에 RUN SQL 사용안해도됨)
select * from dept2;

--문제. unused로 표시된 모든 컬럼을 한꺼번에 제거하는 방법
alter table dept2
drop unused columns;--s:복수

---------------------------------------------------------------------------------------------------------------------------------------
--3.테이명을 변경 : rename 문
rename dept2 to emp2;

--일반적인방법으로 테이블명 확인
select *
from emp2;
--RUN SQL로 변경한 테이블명 확인
desc emp2;

--원상복구
rename emp2 to dept2;

---------------------------------------------------------------------------------------------------------------------------------------
--4.테이블 구조를 제거 : drop table 문
--★demartment 테이블 제거방법-1
--삭제할 테이블의 기본키나 고유키를 다른 테이블에서 참조하고 있는 경우에는 삭제 불가능.
--그래서 참조하는 테이블(자식테이블)을 먼저 제거한 후 부모 테이블을 제거해야한다.(p.255)

drop table department;--다른테이블(사원테이블(=employee))을 참조하고있어 삭제불가능.

drop table employee;--참조하고있는 테이블을 삭제하고난 후
drop table department;--부모테이블 삭제가능

--★demartment 테이블 제거방법-2
drop table department cascade constraintS; --참조키 제약조건까지 함께 제거

select table_name, constraint_name, constraint_type
from user_constraintS
where lower(table_name) in ('employee', 'department');

---------------------------------------------------------------------------------------------------------------------------------------
--5.테이블의 모든 데이터만 제거 : truncate table 문
--테이블 구조는 유지, 테이블에 생성된 제약조건과 연관된 인덱스, 뷰, 동의어는 유지

--데이터 제거 전 확인
select *
from dept2;

--데이터 제거
truncate table dept2;

--데이터 제거 후 확인
--RUN SQL로 데이터 제거 학인(RUN SQL~에는 구조와 타입만 보이기 때문에 사용할 필요없음)☆RUN SQL~에서 select * from dept2;사용하면됨
desc dept2;
--일반적인 방법으로 데이터 제거 확인.
select *
from dept2;

---------------------------------------------------------------------------------------------------------------------------------------
--6.데이터 사전 : 사용자와 DB자원을 효율적으로 관리하기위해 다양한 정보를 저장하는 시스템 테이블 집합
--사용자가 테이블을 생성하거나 사용자를 변경하는 등의 작업을 할 때
--DB서버에 의해 자동으로 갱신되는 테이블
--사용자가 직접 수정할수 없고 삭제할수 없다.->'읽기전용 뷰'로 사용자에게 정보를 제공함

--6-1.USER_데이터 사전 : USER_로 시작 ~ s(=복수)로 끝남
--사용자와 가장 밀접하게 관련된 뷰로 자신이 생성한 테이블, 뷰, 인덱스, 동의어 등의 객체나 해당 사용자에게 권한 정보 제공
--예)user_tables로 사용자가 소유한 '테이블'에 대한 정보조회
select table_name
from user_tableS;--사용자(system)가 소유한 '테이블' 정보

select sequence_name, min_value, max_value, increment_by, cycle_flag
from user_sequenceS;--사용자(system)가 소유한 '시퀀스' 정보 (예 p292참조)

select index_name
from user_indexS;--사용자(system)가 소유한 '인덱스' 정보

select view_name
from user_viewS;--사용자(system)가 소유한 '뷰' 정보

--※객체 : 시퀀스, 인덱스, 뷰 등

--6-2.ALL_데이터 사전
--전체 사용자와 관련된 뷰, 사용자가 접근할 수 있는 모든 객체 정보 조회
--owner : 조회중인 객체가 누구의 소유인지 확인

--예)all_tableS로 테이블에 대한 정보 조회
select owner, table_name
from all_tableS;--사용자(hr)제외된 상태로 결과가 나옴

--6-3.DBA_데이터 사전 : 시스템 관리와 관련된 뷰. DBA나 시스템 권한을 가진 사용자만 접근 가능
--현재 접속한 사용자가 hr(교육용 계정)이라면 DBA_데이터 사전을 조회할 권한 없음 
--DBA 권한 가진 system 계정으로 접속해야 테스트 가능
select owner, table_name
from dba_tableS;--위 문제와 결과 같음

/************************
 ******8장-혼자해보기*******
 ************************/

--1. 다음 표에 명시된대로 dept 테이블을 생성하시오.
--컬럼명  데이터타입       크기
--dno    number     2
--dname  varchar2  14 
--loc    varchar2  13

create table dept(
dno number(2),
dname varchar2(14),
loc varchar2(13)
);

--확인
select *
from dept;

--2. 다음 표에 명시된대로 emp 테이블을 생성하시오.
--컬럼명  데이터타입       크기
--eno    number     4
--ename  varchar2  10 
--dno    number     2

create table emp(
eno number(4),
ename varchar2(10),
dno number(2)
);

--확인
select *
from emp;

--3. 긴 이름을 저장할 수 있도록 emp테이블을 수정하시오. (ename 컬럼의 크기)
--컬럼명  데이터타입       크기
--eno    number     4
--ename  varchar2  25(크기가 수정된 부분) 
--dno    number     2

alter table emp
modify ename varchar2(25);

--확인-run SQL에서 실행
desc emp;

--4. employee 테이블을 복사해서 employee2란 이름의 테이블을 생성하되
--사원번호, 이름, 급여, 부서 번호 컬럼만 복사하고 새로 생성된 테이블의 컬럼명은
--각각 emp_id, name, sal, dept_id 로 지정하시오

--방법1.
create table employee2(emp_id, name, sal, dept_id)
as
select eno, ename, salary, dno
from employee;

--방법2.
--[1]
create table employee2
as
select eno, ename, salary, dno
from employee;
--[2]
alter table employee2
rename column eno to emp_id;

alter table employee2
rename column ename to name;

alter table employee2
rename column salary to sal;

alter table employee2
rename column dno to dept_id;

--확인
select *
from employee2;

--5.emp테이블을 삭제하시오

drop table emp;

--6.employee2 란 이름을 emp로 변경하시오

rename employee2 to emp;

--확인
select *
from emp;

--7.dept 테이블에서 dname 컬럼제거하시오

alter table dept
drop column dname;

--확인
select *
from dept;

--8.dept 테이블에서 loc컬럼을 unused로 표시하시오

alter table dept
set unused(loc);

--확인 --run sql에도 안나옴.
select *
from dept;

--9.unused 컬럼을 모두 제거하시오.

alter table *
drop unused columns;

--확인
select*
from dept;

--원상복구
drop table dept;
drop table emp;

/*************************************************************************************************************************************/