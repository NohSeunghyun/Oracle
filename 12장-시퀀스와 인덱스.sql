--<북스-12장. 시퀀스와 인덱스>
--1. 시퀀스 생성
--시퀀스 : 테이블 내의 유일한 숫자를 자동생성
--오라클에서 데이터가 중복된 값을 가질 수 있으나
--'개체 무결성'을 위해 항상 유일한 값을 갖도록 하는 '기본키'를 두고 있음 //기본키(=primary key) not null+unique
--시퀀스는 기본키가 유일한 값을 반드시 갖도록 자동생성하여 사용자가 직접 생성하는 부담감을 줄임

create sequence 시퀀스명
[start with n] --시퀀스 시작번호
[increment by n] --증가치
[maxvalue n | nomaxvalue] --최대값 | nomaxvalue : 증가시 (10의 27제곱), 감소시(-1)
[minvalue n | nominvalue] --최소값 | nominvalue : 증가시 (1), 감소시(10의 26제곱)
[cycle | nocycle(기본값)] --cycly : 최대값까지 증가 후 start with 지정한 값으로 다시 시작
--						 nocycle : 최대값까지 증가 후 그다음 시퀀스를 발급받으려면 에러발생
[cache n | nocache] --cache :메모리상에서 시퀀스 값을 관리 기본값은20
--					nocache : 메모리상에서 시퀀스 값을 관리x
[noorder(기본값) | order]
--order : 병렬서버를 사용할 경우 요청 순서에 따라 정확하게 시퀀스를 생성하기를 원할 때 order로 지정
--		    단일서버일 경우 이 옵션과 관계없이 정확히 요청 순서에따라 시퀀스가 생성
;

create sequence sample_seq
start with 10
increment by 10;

select *
from user_sequenceS
where lower(sequence_name) = 'sample_seq'; --이렇게 쓸 경우 대,소문자로 사용해도됨, lower을 제거하고 컬럼명만 사용할경우 무조건 대문자

--1-1. nextval(다음값 생성) -> currval(현재값 알아냄)(★사용순서 주의)
select sample_seq.nextval
from dual;

select sample_seq.currval
from dual;--오류 발생

select sample_seq.nextval, sample_seq.currval
from dual;

select sample_seq.currval, sample_seq.nextval
from dual;--순서 관계없이 실행됨

--1-2. 시퀀스를 기본키에 접목하기
--부서테이블의 기본키는 반드시유일한 값을 가져야함.
--유일한 값을 자동으로 생성해주는 시퀀스 사용
create table dept12
as
select * from department; --제약조건 복사안됨(현재 dno는 기본키(primary key)가 아니다)

create sequence dno_seq
start with 10
increment by 10;

insert into dept12 values (dno_seq.nextval, 'ACCOUNTING', '서울시');

select * from dept12;

--2. 시퀀스 수정 및 제거 : start with 값만 제외하고 alter sequence 명령어로 수정가능
--					 이유? 이미 사용중인 시퀀스의 시작값을 변경할 수 없으므로
--					 시작번호를 다른번호로 변경하고 싶다면 이전 시퀀스를 drop으로 삭제 후 다시 생성
alter sequence 시퀀스명
--[start with n] --시퀀스 시작번호
[increment by n] --증가치
[maxvalue n | nomaxvalue] --최대값 | nomaxvalue : 증가시 (10의 27제곱), 감소시(-1)
[minvalue n | nominvalue] --최소값 | nominvalue : 증가시 (1), 감소시(10의 26제곱)
[cycle | nocycle(기본값)] --cycly : 최대값까지 증가 후 start with 지정한 값으로 다시 시작
--						 nocycle : 최대값까지 증가 후 그다음 시퀀스를 발급받으려면 에러발생
[cache n | nocache] --cache :메모리상에서 시퀀스 값을 관리 기본값은20
--					nocache : 메모리상에서 시퀀스 값을 관리x
[noorder(기본값) | order]
--order : 병렬서버를 사용할 경우 요청 순서에 따라 정확하게 시퀀스를 생성하기를 원할 때 order로 지정
--		    단일서버일 경우 이 옵션과 관계없이 정확히 요청 순서에따라 시퀀스가 생성
;

select *
from user_sequenceS
where sequence_name in('DNO_SEQ');

alter sequence dno_seq
maxvalue 20;

insert into dept12 values (dno_seq.nextval, 'ACCOUNTING', '대구시');--20
insert into dept12 values (dno_seq.nextval, 'ACCOUNTING', '부산시');--실패 이유?maxvalue 20으로 설정해서

--시퀀스 제거
drop sequence dno_seq;

---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
--3. 조회시 서능 향상을 위한 인덱스
--인덱스 : 기본키(=primary key)나 유일키(=unique)는 자동생성
--user_indexES나 user_IND_columnS 데이터사전에서 인덱스 객체 확인 가능
--indexES를 사용시 컬럼에 관한것은 출력하지 못한다.

--두 테이블에 자동으로 생성된 인덱스 살피기
select index_name, table_name, column_name
from user_IND_columnS
where lower(table_name) in ('employee', 'department');

--직접 인덱스 생성
create index idx_emp_ename
on employee(ename);

--생성확인
select index_name, table_name, column_name
from user_IND_columnS
where lower(table_name) in ('employee');
--하나의 테이블에 인덱스가 많으면 DB성능에 좋지않은 영향을 미친다->위 생성 인덱스 제거
drop index idx_emp_ename;

--제거확인
select index_name, table_name, column_name
from user_IND_columnS
where lower(table_name) in ('employee');

---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
--★교재 이외 내용
--예1) 사원테이블을 복사해서 새로운 테이블을 생성한 후 인덱스 유무에 대한 검색 속도 비교
create table emp12
as
select *
from employee; --제약조건은 생성되지않음->index 생성되지않음

--제약조건과 인덱스 확인 ->없음
select *
from user_IND_columnS
where lower(table_name) in ('emp12');

--데이터 복사확인
select * from emp12;

insert into emp12 select * from emp12;--자기자신의 데이터를 전부 추가한다
--제약조건이 복사안되었기 때문에 중복허용되므로 중복입력가능

--중복 복사 확인
select * from emp12;

--검색시간체크를 위해(RUN SQL~에서 사용)
set timing on;

--test1 - index X - 조회 시 시간 측정
--사원이름이 'KIM'인 행을 검색
select distinct eno, ename 
from emp12 
where ename='KIM';
--Elapsed : 00:00:00.00(데이터가 적어서 0으로 나옴)-테스트 실패

--test2 - index O - 조회시 시간 측정
--인덱스 생성
create index idx_emp12_ename
on emp12(ename);

--인덱스 생성 유무 확인
select *
from user_ind_columns
where table_name = 'EMP12';

select *
from user_indexES--★주의 : index+ES
where table_name = 'EMP12';

--사원이름이 'KIM'인 행을 검색(ename에 대한 index 생성한 상태)
select distinct eno, ename
from emp12
where ename = 'KIM';
--Elapsed : 00:00:00.00(데이터가 적어서 0으로 나옴)-테스트 실패
---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
--299p
--인덱스 내부구조는 B-TREE(=균형트리)로 구성
--컬럼에 인덱스를 설정하면 이를 B-TREE로 생성되어야 하기 때문에
--인덱스 생성을 위한 시간도 필요하고 인덱스를 위한 추가 공간도 필요

--인덱스 생성 후에->새로운 행을 추가하거나 삭제할 경우
--인덱스로 사용된 컬럼값도 함께 변경->내부구조(B-TREE)도 함께 변경
--오라클 서버가 이 작업을 자동으로 발생하므로 인덱스 있는 경우의 DML작업이 훨씬 무거워짐
--계획성없이 너무많은 인덱스를 지정하면 오히려 성능 저하 유발됨

---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
--★교재 이외 내용
--예)인덱스 사용해야하는 경우
select distinct dname
from emp12
where dno=10;

--쿼리문의 조건이
--1.테이블에 전체 행의 수가 많을때 : 10000건
--2.where문에 해당 컬럼이 많이 사용될 때 : 위 쿼리문이 전체 쿼리문 중에서 95%사용됨
--3.검색결과가 전체 데이터의 2~4% 정도일 때 : 
--쿼리문의 결과로 구해지는 행 10건정도라면 dno컬럼은 인덱스를 사용하는것이 적당하다
--검색결과가 전체 데이터의 2~4%정도 이므로 인덱스가 있어야 검색이 빨라진다

--인덱스가 생성된 후에 새로운 행이 추가, 삭제, 갱신작업이 잦으면
--node의 갱신이 주기적으로 일어나 '단편화'현상 발생
--단편화? 삭제된 레코드의 인덱스값 자리가 비게되는 상태 ->검색성능 저하
--따라서 인덱스 다시 생성하여 기존의 단편화가 많은 인덱스를 버리는 작업을 하여 효율을 높인다.
alter index idx_emp12_ename rebuild;--재생성

--4.인덱스 종료
--4-1. 고유/비고유 인덱스
--고유 인덱스 : 기본키, 유일키처럼 유일한 값을 갖는 컬럼에 생성된 인덱스 예)부서테이블의 부서번호
--비고유 인덱스 : 중복된 데이터를 갖는 컬럼에 생성된 인덱스 예)부서테이블의 부서명이나 지역명

--고유 인덱스 지정하기
create unique index idx_dept_dno
on dept12(dno);--cannot CREATE UNIQUE INDEX; duplicate keys found 오류 발생-중복된 키 발견 = 중복된 dno값이 있기때문에 오류남.
--오류확인
select * from dept12;--dno가 10,20 중복된것이 있기때문에

--위 실행문이 안되므로 비고유 인덱스 지정하기
create index idx_dept_dno
on dept12(dno);--비고유 인덱스 생성

--생성확인
select *
from user_ind_columnS
where table_name = 'DEPT12';

--테이블 dept12_2생성
create table dept12_2
as
select *
from department;--제약조건 복사안됨

--고유 인덱스 생성
create unique index idx_dept_dno2
on dept12_2(dno);

--생성확인
select *
from user_ind_columnS
where table_name = 'DEPT12_2';

--생성확인
select table_name, index_name
from user_indexES
where lower(table_name) = 'dept12_2';

--지금까지 생성한 인덱스는 단순인덱스(한개의 컬럼으로 구성한 인덱스)
----------------------------------------------------
--4-2. 결합인덱스 : 2개이상의 컬럼으로 구성한 인덱
create index idx_dept_dname_loc
on dept12(dname, loc);

--생성확인
select table_name, index_name
from user_indexES
where lower(table_name) = 'dept12';

--언제 idx_dept_dname_loc 인덱스를 이용하여 검색속도를 높이는가
select
from dept12
where dname='' and loc='';
--위 쿼리가 거의 사용되지 않는다면 오히려 성능 저하

select
from dept12
where dname='';
--dname에 인덱스가 없으면
--dname, loc조합한 인덱스를 사용하여 검색
--따라서 전체 테이블 검색보다 더 효율적임

--4-3. 함수기반 인덱스 : 수식(=산술식)이나 함수를 적용하여 만든 인덱스
create index idx_emp_salary12
on emp12(salary*12);--수식이므로 컬럼명이 없어서 가상컬럼 생성됨

--사전확인
select table_name, index_name, column_name
from user_ind_columnS
where table_name in ('EMP12');

---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
--★교재 이외 내용
--4-4. INvisible index
--인덱스를 실제 삭제하기 전에 "사용 안 함" 상태로 만들어서 테스트해 볼 수 있는 기능을 제공하는 인덱스

--예)inx_emp12_ename 인덱스 생성
--인덱스 사전을 통해 visibility컬럼값 확인

--인덱스 생성
create index idx_emp12_ename
on emp12(ename);--이미 존재함

--사전확인
select index_name, visibility
from user_indexES
where table_name = 'EMP12';

alter index idx_emp12_ename
invisible;

/************************
 ******12장-혼자해보기******
 ************************/
--문제1. 사원테이블의 사원번호가 자동으로 생성되도록 시퀀스를 생성하시오.
--시작번호 1 부터 1씩 증가 타입크기가 4이니 9999까지
create sequence emp_seq
start with 1
increment by 1
maxvalue 9999;

--생성확인
select *
from user_sequenceS
where sequence_name in('EMP_SEQ');

--문제2. emp01테이블을 생성하시오. 생성 후 사원번호를 시퀀스로부터 발급받으시오
-- eno는 number(4) 기본키, ename은 varchar2(10), hiredate는 date로
--원상복구
drop table emp01;

--테이블생성
create table emp01(
eno number(4) primary key,
ename varchar2(10),
hiredate date
);

--생성확인(구조는 RUN SQL~에서)
desc emp01;

--시퀀스로부터 사원번호 발급받기
insert into emp01 values (emp_seq.nextval, '노', sysdate);

--추가후 시퀀스로부터 발급받은것 확인
select *
from emp01;

--문제3. emp01테이블의 이름 컬럼을 인덱스로 설정하되 인덱스이름을 idx_emp01_ename로 지정하시오
create index idx_emp01_ename
on emp01(ename);

--데이터 사전을 통해 인덱스 추가확인
select *
from user_indexES
where table_name = 'EMP01';

/**************************************************************************************************************************************/