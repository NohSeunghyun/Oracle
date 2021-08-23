--<북스-13장. 사용자 권한과 테이블 스페이스>
--테이블 스페이스
--오라클에서는 data file 이라는 물리적 파일형태로 저장하고
--이러한 data file 하나 이상 모여서 Tablespace라는 논리적인 공간을 형성함

--오라클 DB는 2가지 유형의 Tablespace로 구성
--1. system Tablespace(필수, 기본)
--	 DB운영에 필요한 기본정보를 담고있는 data Dictionary Table이 저장되는 공간으로
--	 DB에서 가장 중요한 Tablespace
--	  중요한 데이터가 담겨져있는 만큼 문제가 생길경우 자동으로 데이터베이스를 종료될수 있으므로
--	  일반 사용자들의 객체들을 저장하지 않는것을 권장함
--	 (혹여나 사용자들의 객체에 문제가 생겨 데이터베이스가 종료되거나
--	    완벽한 복구가 불가능한 상황이 발생할 수 있기 때문에)

--	 Data Dictionary 정보
--   SYSTEM Rollback Segment 포함
--   사용자 데이터 포함 가능 (예)오라클 설치하면 기본으로 저장되어 있는 emp나 dept테이블(이 테이블들은 사용자들이 사용가능함)

--2. non-system Tablespace
--	  보다 융통성있게 DB를 관리할 수 있다.
--	 Rollback Segment,
--	 Temporary Segment,
--	 Application Data Segment,
--	 Index Segment,
--	 USER Data Segment 포함
------------------------------------------------------------------------------------------------------

/* 	물리적단위		논리적단위
 * 				DATABASE
 * 				   |
 * 	datafile	TABLESPACE
 *	(*.dbf)		   |
 *	 			SEGMENT : 1개의 segment는 여러개의 extent로 구성
 * 				   |
 * 				EXTENT : 1개의 extent는 여러개의 DB block로 구성
 * 				   |	 extent는 반드시 메모리에 연속된 공간을 잡아야함(단편화가 많으면 디스크 조각모음으로 해결)
 * 				   |
 * 				DB block : 메모리나 디스크에서 I/O 할 수 있는 최소단위 (I/O = Input/Output)
 */
		
------------------------------------------------------------------------------------------------------
--유저의 테이블스페이스 조회
select default_tablespace
from user_userS;

--1-1. 테이블 스페이스 만들기
--1) tablespace 생성
create tablespace test_data
datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data1.dbf' 
size 10M
default storage (initial 2M --처음 생성 2M
				next 1M --2M가 꽉 차면 그다음 extent 1M 생성(extent는 반드시 메모리에 연속된 공간을 잡아야함)
				minextents 1 --생성할 extent의 최소 개수(최소 1회부터)
				maxextents 121 --생성할 extent의 최대 개수(최대 121회 발생가능. 122회 불가능(오류))
				pctincrease 50); --기본값 : 0. 다음 할당할 extent의 수치를 %로 나타냄
--pctincrease 50%으로 지정하면 처음은 1M(정확히 1024Kb), 두번쨰부터는 next 1M의 반인 500K(512Kb) extent가 만들어짐
--그다음에 또 512K의 반인 256K 할당.....

--2) tablespace 조회
select tablespace_name, status, segment_space_management 
-- segment_space_management는 테이블스페이스의 자동크기조절 
from dba_tablespaceS;--모든 테이블스페이스의 storage정보 및 상태정보

--1-2. 테이블 스페이스 변경
--test_data 테이블 스페이스에 datafile 1개 더 추가하기
alter tablespace test_data
add datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data2.dbf' size 10M;
--10M+10M -> 총 20M
--즉, 물리적으로 2개의 파일로 구성되어진 하나의 테이블 스페이스가 만들어짐

--1-3. 테이블 스페이스의 data file의 크기조절
--1) 자동으로 크기조절
alter tablespace test_data
add datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data3.dbf' size 10M
autoextend on
next 1M
maxsize 250M;
--test data03.dbf의 크기인 10M가 부족하면 자동으로 1M씩 늘어나 최대 250M까지 늘어남
--★주의 : maxsize 250 -> unlimited(=무제한)변경하면 문제발생
-----예) 리눅스에서는 파일1개를 핸드링(=처리)할 수 있는 사이즈가 2G로 한정되어 있으므로
-------- 따라서, data file이 2G를 넘으면 그때부터 오류발생하므로 
-------- 가급적이면 maxsize를 지정하여 사용하는것이 바람직하다(권장)

--2) 수동으로 크기조절(★주의 : alter database)
alter database
datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data2.dbf' resize 20M; --10M->20M

--하나의 테이블 스페이스(=test_data)(논리적) = 총 40M인 3개의 물리적 data file로 구성됨

--1-4. data file 용량조회
--1)data file 용량조회
select tablespace_name, bytes/1024/1024 MB, file_name, autoextensible auto
--autoextensible는 데이터파일의 자동크기조절
from dba_data_fileS;

--2)테이블스페이스의 수집가능한 extend에 대한 통계 정보 조회
select tablespace_name, total_extents, extents_coalesced, percent_extents_coalesced
from dba_free_space_coalesced;
--total_extents : 사용가능한 extent 수
--extents_coalesced : 수집된 사용가능한 extent 수
--percent_extents_coalesced : 그 비율은 몇 % ?

--1-5. 테이블 스페이스 단편화된 공간 수집 : 즉 ,디스크 조각모음
--alter tablespace 테이블스페이스명 coalesce;
alter tablespace test_data coalesce;
--위 명령은 8번씩 수집한 뒤에 자동으로 commit;됨
--따라서  dba_free_space_coalesced를 조회해보고 필요에 따라서 여러번 실행해야한다.

--1-6. 테이블 스페이스 제거하기
--형식
drop tablespace 테이블스테이스명;--테이블 스페이스 내에 객체가 존재하면 삭제불가
--[including contents;]--옵션1. 모든 내용(객체) 포함하여 삭제. 생략가능(단, 테이블 스페이스 내에 비어있을경우에만)
					   --그러나, 탐색기에서 확인해보면 물리적 data file은 삭제가안됨
--[including contents and datafiles;]--옵션2. 물리적 data file까지 함께 삭제
--[cascade constraints;]--옵션3. 참조되어있는 제약조건까지 함께 삭제

--먼저, 테이블 하나를 생성
create table test3(
a char(1)
)
tablespace test_data;

drop tablespace test_data;--실패 : tablespace not empty, use INCLUDING CONTENTS option

--해결법
drop tablespace test_data
including contents;--테이블스페이스의 모든 내용 함께 삭제
--성공. 논리적 테이블스페이스는 삭제됨. 물리적 데이터파일은 삭제가안됨(=탐색기에서 확인해보면 데이터파일은 삭제가 안됨 따라서 직접 삭제해줘야함.)

--데이터파일까지 삭제하기
drop tablespace test_data
including contents and datafiles;

--그런데 A테이블스페이스의 사원테이블(dno:FK)이 B테이블스페이스의 부서테이블(dno:PK)을 참조하는 상황에서 
--B테이블스페이스를 위 방법처럼 삭제한다면 '참조 무결성'에 위배되므로 오류발생
drop tablespace test_data
including contents and datafiles
cascade constraints;--참조 제약조건들까지 삭제하여 해결가능

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
--교재
--1. 사용권한
--오라클 보안 : 시스템 보안, 데이터 보안
--시스템 보안 : DB에 접근 권한. 사용자 계정과 암호 입력해서 인증받아야 함
--데이터 보안 : 사용자가 생성한 객체에 대한 소유권을 가지고 있기 떄문에
--			 데이터를 조회하거나 조작할 수 있지만
--			 다른 사용자는 객체의 소유자로부터 접근 권한을 받아야 사용가능

--권한 : 시스템을 관리하는 '시스템 권한', 객체를 사용할 수 있도록 관리하는 객체 권한

--308p 표-시스템 권한 참조 : DBA 권한을 가진 사용자가 시스템 권한을 부여함
--1.create session : DB에 접속(연결)할 수 있는 권한
--2.create table : 테이블 생성할 수 있는 권한
--3.unlimited tablespace : 테이블스페이스에 블록을 할당할 수 있도록 해주는 권한
--  그러나 unlimited tablespace 사용 시 문제 발생 할 수 있다.(default tablespace인 system의 보안상)
--  그러나 default tablespace를 다른 테이블스페이스(users)로 변경하고 quota절로 사용할 용량()을 할당해준다.(이때, unlimited로 할당해줘도 무방) 
--4.create sequence : 시퀀스 생성권한
--5.create view : 뷰 생성권한
--6.select any table : 권한을 받은자가 어느테이블, 뷰 라도 검색가능
--이 외에도 100여개 이상의 시스템권한이 존재.
--dba는 사용자를 생성할 때 마다 적절한 시스템권한을 부여해야한다.

--2.시스템 권한 부여
/*
 * 시스템 권한
 * grant 'create session' to 사용자|롤|public(=모든사용자) [with admin option]
 */
--<실습>
--'DBA 권한'을 가진 SYSTEM으로 접속하여 사용자의 이름과 암호 지정하여 사용자 생성 (Run SQL~에서)
conn system/1234; -- system에 접속 후 
--			 아이디			         패스워드
create user user01 identified by pass1; -- 유저 생성 후 
conn user01/pass1; -- 오류발생 - DB 접속 권한을 안줬기 때문에
conn system/1234; -- 다시 system에 접속 후
grant create session to user01; -- DB 접속 권한 부여
conn user01/pass1; -- user 01에 접속 성공
create table sampletbl(no number); -- 오류발생 - 테이블 생성 권한을 안줬기 때문에
conn system/1234; -- 다시 system에 접속 후
grant create table to user01; -- 테이블 생성 권한 부여
conn user01/pass1; -- user01에 접속 후
create table sampletbl(no number); -- 다시 오류발생 - 테이블스페이스 값을 줘야함(=default_tablespace는 system이지만 용량을 할당받지못함)

--테이블생성 오류 해결 방법1
conn system/1234; -- 다시 system접속 후
grant unlimited tablespace to user01; --default_tablespace인 system용량을 무제한 사용
-- 테이블 생성, 테이블 용량 할당 권한부여
--그러나 권한 부여 후 문제가 발생할 수 있다.(system 테이블스페이스의 중요한 데이터의 보안상)

--user01의 default_tablespace 확인
select username, default_tablespace
from dba_userS
where lower(username) in ('user01'); -- default_tablespace : system

select username, tablespace_name, max_bytes
from dba_ts_quotas --quota가 설정된 user만 표시
where lower(username) in ('user01');
--결과가 없음 : user01은 quota가 설정안됨
--그래서 default_tablespace를 tast_data로 변경 후 quota를 설정

--테이블생성 오류 해결 방법2
conn system/1234; -- 다시 system접속 후
alter user user01 default tablespace test_data
quota 5M on test_data; -- users; -- 테이블 스페이스를 만든것이 있다면 그것을 사용해도됨. ex)test_data <- 위에서 만들어놓은것 
--users 테이블스페이스는 사용자를 위해 미리 만들어진 테이블스페이스

alter user user01
quota 2M on users;

alter user user01
quota unlimited on users; -- 데이터사전에 무제한은 -1로 표시됨

--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓정리↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
--안전한 user 생성 방법
--conn 접속유저명/패스워드; -- 시스템에 접속 후 (단, dba관리자로 접속해야함. sysdba나 첫날 만들어놓은 system)
--create user 유저명 identified by 비밀번호; -- 유저 생성 후
--grant connect, resource to user01;
--습관적으로 권한을 주는데 resource롤을 주면 unlimited tablespace까지 주기에
--system(현재의 default_tablespace)의 테이블스페이스 용량을 무제한으로 사용가능하게되어
--보안 혹은 관리상에 문제가 될 소지를 가지고있다.

--[1]dba관리자로 접속
conn system/1234;--첫날 만들어놓은 dba권한을 가진 유저

--[2]user생성
create user user02 identified by 1234;

--[3]권한 부여
grant connect, resource to user02;

--테이블스페이스 확인
select username, default_tablespace
from dba_userS
where lower(username) in ('user02'); --system

--★★★여기까지하면 자동으로 resource롤에 unlimited tablespace가 있다는데
--★★★데이터사전을 통해 확인해보면 아예 없는것으로나온다. -1도 안나옴 확인해봐야함
--[4]unlimited tablespace에 대한 권한 회수 (회수는 반드시 권한을 준 dba관리자만 회수가능(=system))
revoke unlimited tablespace from user02;

--[5]user02의 default_tablespace를 변경, quota절로 용량할당
alter user user02
default tablespace users--테이블스페이스지정 (system->users로변경)
quota 10M on users;--quota 할당할 용량 크기 on 해당테이블스페이스명 (unlimited -> 10M로 변경)

--테이블스페이스 확인
select username, default_tablespace
from dba_userS
where lower(username) in ('user02');

--할당 크기 확인
select username, tablespace_name, max_bytes
from dba_ts_quotas
where lower(username) in ('user03');

--with admin option
--실습-1 : dba권한을 가진 system에 접속하여 a_user 생성 후 db접속권한(with admin option 부여)
conn system/1234;--접속
create user a_user identified by 1234;--생성
grant create session to a_user with admin option;--db접속 권한 부여(with admin option부여)
--실습-2 : dba권한을 가진 system에 접속하여 b_user 생성 후 with admin option을 부여받은 a_user로 접속 후 b_user에게 db접속권한 부여
conn system/1234;--접속
create user b_user identified by 1234;--생성
conn a_user/1234;--부여권한 확인을 위한 접속성공 및 접속
grant create session to b_user;--권한부여

--확인
conn b_user/1234;--부여권한 확인을 위한 접속 성공
--실습-3 : b_user로 접속 후 a_user가 가진 접속권한 회수
conn b_user/1234;--접속
revoke create session from a_user;--성공! ?? 서로가 평등한 관계이므로 회수가능;
------------------------------------------------------------------------------------------------------
--3. 롤 (321p) : 다양한 권한을 효과적으로 관리할 수 있도록 관련된 권한끼리 묶은것
--여러 사용자에게 보다 간편하게 권한을 부여할 수 있도록 함
--예) grant connect, resource, dba to system;
--1)dba롤 : 시스템 자원을 무제한적으로 사용, 시스템 관리에 대한 모든 권한
--2)connect롤 : Oracle 9i 버전 까지 - 교재 321p에 있는 8가지, Oracle 10g부터는 create session만 가지고 있다.
--3)resource롤 : 객체(테이블, 뷰 등)를 생성할 수 있도록 하기위해서 시스템 권한을 그룹화
------------------------------------------------------------------------------------------------------
--유저 비밀번호 바꾸기
--dba관리자로 접속
--alter user 유저명 identified by 새비밀번호;

--lock된 유저 해제하기
--dba관리자로 접속
--alter user 유저명 account unlock;
------------------------------------------------------------------------------------------------------
--소유한 객체의 사용권한 관리를 위한 명령어 : DCL(grant(부여), revoke(회수)) (=데이터 제어어)
--4.객체 권한 부여(313p) : dba관리자나 (sysdba, system) 객체소유자가 다른 사용자에게 권한을 부여할 수 있다.
--						★★★dba관리자가 다른사용자에게 권한부여한다면 어디의 객체인지 명확히해야함.
--						ex)dba관리자로 접속하여 hr의 employees객체를 조회할수있는 권한을 user01에게준다.
--							conn system/1234;--관리자로 접속
--							grant select on hr.employees to user01;
/*
 * 객체 권한
 * grant 'select|insert|update|delete...' on 객체 to 사용자|public(=모든사용자) [with grant option]
 * 예) grant all(모든 권한) on 객체 to 사용자 : 사용자에게 객체에 대한 모든 권한을 부여하겠다.
 */ 
--1). select on 테이블명
--유저생성
conn system/1234;--dba권한 사용자(=관리자)로 접속
alter user user01 identfied by pass1;--유저 생성
grant create session to user 01;--유저 접속 권한 부여

--employee테이블 조회
conn user01/pass1;--권한받은 사용자로 접속
select * from employees;--user01은 employees 테이블이 없어서 오류
select * from hr.employees;--hr이 가지고있는 employees 테이블은 조회 권한이 없어서 오류

--객체 소유자로부터 권한부여받기
conn hr/1234;--객체 소유자로 접속 실패 - lock되어있어서 실패
--lock 해제
conn system/1234;--dba권한 사용자로 접속
alter user hr account unlock; --lock해제
conn hr/1234;--객체 소유자로 접속 성공
grant select on employees to user01;--user01에게 select권한 부여

--다시 조회
conn user01/pass1;--권한받은 사용자로 접속
select * from hr.employees;--성공

--2). insert on 테이블명
--객체 소유자로부터 권한 부여받기
conn hr/1234;--객체 소유자로 접속
grant insert on employees to user01;--user01에게 insert권한 부여

--추가 해보기
conn user01/pass1;--권한받은 사용자로 접속
desc hr.employees;--테이블 구조확인, not null컬럼에 대해서만 값을 부여(나머지는 null값 자동삽입) 단, first_name도 추가.이름넣기위해
insert into hr.employees(employee_id, first_name, last_name, email, hire_date, job_id) values (123456, '승현', '노', 'tatsos93', sysdate, 'AC_ACCOUNT');

--3). update(특정 컬럼(예.salary)) on 테이블명
--객체 소유자로부터 권한 부여받기
conn hr/1234;--객체 소유자로 접속
grant update(salary) on employees to user01;--user01에게 '테이블의 특정컬럼 수정권한'부여

--업데이트 해보기
conn user01/pass1;--권한받은 사용자로 접속
update hr.employees set salary=1000 where employee_id=123456; --성공
update hr.employees set commission=500 where employee_id=123456;--실패, 커미션 수정에 대한 권한없음

--5.객체권한 회수=제거=박탈
--dba관리자나 권한을 부여한 사용자가 다른 사용자에게 부여한 객체 권한을 박탈
--revoke 객체권한 from 권한받은 사용자
--객체 소유자로 권한 박탈
--1)revoke 'select|insert|update|delete...' on 객체 from 부여받았던 사용자
conn hr/1234;--객체 소유자로 접속
revoke select on employees from user01;--user01에게 준 employee를 조회할수있는 권한을 박탈
revoke insert on employees from user01;--user01에게 준 employee에 데이터 추가할수있는 권한을 박탈
revoke update(salary) on employees from user01;--user01에게 준 employee의 salary컬럼 데이터 수정할수있는 권한을 박탈

conn user01/pass1;--권한받은 사용자로 접속
select * from hr.employees;--실패.권한 박탈받았기 때문

--2)revoke all on 테이블명 from 부여받았던 사용자
conn hr/1234;--객체 소유자로 접속
revoke all on employees from user01;--user01에게 준 employee에 대한 모든 권한을 박탈
revoke all on employees from public;--권한을 부여받았던 모든 사용자의 employee에 대한 모든 객체권한 회수

--확인
conn user01/pass1;--권한받은 사용자로 접속
update hr.employees set salary=5000 where employee_id=123456;--실패.권한 박탈받았기 때문
--메세지 : table or view does not exist 이유? 아예 조회도 안됨

--with grant option : 부여받은 객체 권한을 다른 사용자에게 다시 부여할수 있다.
--실습
--1)관리자접속
conn system/1234;--dba관리자나 권한을 부여받은 사용자(with admin option)만 시스템권한을 부여할 수 있다

--2)유저 2개 생성 -> 권한부여 (시스템권한)
create user usertest01 identified by 1234;
create user usertest02 identified by 1234;

grant create session, create table, create view to usertest01;
grant create session, create table, create view to usertest02;

--3-1)hr로 접속하여 hr의 객체(employee)권한 부여 with grant option으로
conn hr/1234;
grant select on employees to usertest01 with grant option;
--3-2)dba관리자로 권한부여한다면?
conn system/1234;
grant select on hr.employees to usertest01 with grant option;
--4)with grant option으로 권한부여받은 usertest01로 접속하여 usertest02에게 권한부여
conn usertest01/1234;
grant select on hr.employees to usertest02;-- 누구의 객체인지 명확히 해야함.

--권한확인
conn usertest02/1234;
select * from hr.employees;

--with grant option 상태에서 권한 박탈
--권한부여한 소유자로 접속
conn hr/1234;
revoke select on employees from usertest01; -- with grant option 안써도 자동으로 연쇄적(cascade)으로 권한박탈.
										--최초 with grant option을 받은 사용자를 적어야함
										
/************************************************************************************************************************************/