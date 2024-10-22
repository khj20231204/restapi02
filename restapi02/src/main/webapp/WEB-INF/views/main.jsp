<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	a:link {text-decoration:none}
	a#subject {letter-spacing:20px}        
</style>

<script src="http://code.jquery.com/jquery-latest.js"></script>
<script>
$(document).ready(function(){
	
	// 초기 버튼 설정
	$("#write").hide();       // 글작성
	$("#update").hide();      // 글수정
	$("#delete").hide();      // 글삭제
	
	$("#list").click(function(){		// 글목록 버튼 클릭
		boardlist(1);
	});
	
});


// 글작성 폼
function writeform(){

	$("#write").hide();
	$("#mytable").hide();
	$("#pagination").hide();
	$("#writeform").show();
	
	var content = "<form id='writeform'><table border=1 width=300>"
	    content += "<tr><th>작성자</th><td><input type=text id=writer1 name=writer></td></tr>" 
	    content += "<tr><th>비밀번호</th><td><input type=text id=passwd1 name=passwd></td></tr>" 
	    content += "<tr><th>제목</th><td><input type=text id=subject1 name=subject></td></tr>"
	    content += "<tr><th>내용</th><td><input type=text id=content1 name=content></td></tr>"							
	    content += "<tr><td colspan=2 align=center>"							
	    content += "<input type=button value=글작성  onClick='boardwrite()'>"							
	    content += "</td></tr></table></form>"							
	
	$("#writeform").html(content);	
}

// 글작성
function boardwrite(){
	alert("글작성");
	
	var formData = {
	        writer: $("#writer1").val(),
	        passwd: $("#passwd1").val(),
	        subject: $("#subject1").val(),
	        content: $("#content1").val()
	    };
	
	$.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/board/boardwrite",
		//${pageContext.request.contextPath} 프로젝트명, 잘 못 찾아갈때
		contentType: 'application/json',  	// 데이터 타입을 JSON으로 설정
		data : JSON.stringify(formData),  	// 데이터를 JSON 문자열로 변환하여 전송
		success : function(result){
			if(result == 1){
				alert("글작성 성공");
			}else{
				alert("글작성 실패");
			}
			boardlist(1);  					// 글작성후 목록 페이지로 이동
		}	
	});	
}

// 게시판 목록
function boardlist(page){
	$("#writeform").hide();
	$("#detail").hide();
	$("#updateform").hide();
	$("#deleteform").hide();
	
	$("#mytable").show();
	$("#pagination").show();
	
	$.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/board/boardlist/"+page,
		//값을 받을 땐 page 1개이기 때문에 PathVariable로 받는다
		//		url : "http://localhost/restapi02/board/boardlist/"+page,
		success : function(result){	 //넘겨줄 때 map으로 넘겨주었기 때문에 result. 으로 바로 변수값으로 접근가능	
			var no = result.listcount - (result.page - 1) * 10;    // 화면출력 번호
			var content = "<tr><th>번호</th><th>제목</th><th>작성자</th><th>날짜</th><th>조회수</th></tr>"
			
			$.each(result.boardlist, function (index, item) { //reuslt.리스트 는 each로 돌려준다
		          content += "<tr><td>" + no-- + "</td>";
		          content += "<td><a href='javascript:boardcontent(" + item.no + "," + page + ")'>" + item.subject + "</a></td>";
		          content += "<td>" + item.writer + "</td>";
		          
		       // register를 연,월,일 시분초로 변환
	              var date = new Date(item.register);
	              var formattedDate = date.getFullYear() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate()) +
	                  " " + addZero(date.getHours()) + ":" + addZero(date.getMinutes()) + ":" + addZero(date.getSeconds());
	                
	              content += "<td>" + formattedDate + "</td>";	          
		          
		         /*  content += "<td>" + item.register + "</td>"; */
		          content += "<td>" + item.readcount + "</td></tr>";
		    });			
			$("#mytbody").html(content);
			
			// 페이징 처리 추가
            var pagination = "<div style='text-align:center'>";
            for (var i = result.startPage; i <= result.endPage; i++) {
                pagination += "<span class='page-item " + (i === result.page ? "active" : "") + "'>";
                pagination += "<a id=subject href='javascript:boardlist(" + i + ")'>" + i + "</a></span>";
            }
            pagination += "</div>";
            $("#pagination").html(pagination);
			
		}			
	});	
	
	$("#write").show();
	$("#write").click(function(){
		writeform();
	});
}

//10보다 작은 숫자에 0을 추가하는 함수
function addZero(number) {
    return number < 10 ? "0" + number : number;
}


// 상세 페이지
function boardcontent(no, page){
	$("#write").hide();
	$("#mytable").hide();
	$("#pagination").hide();
	$("#detail").show();	

	$.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/board/boardcontent/"+no+"/"+page,
		success : function(result){
			
			var content = "<table border=1><caption>상세페이지</caption>"
			    content += "<tr><th>번호</th><td>"+result.board.no+"</td></tr>"
			    content += "<tr><th>제목</th><td>"+result.board.subject+"</td></tr>"
			    content += "<tr><th>작성자</th><td>"+result.board.writer+"</td></tr>" 
			    content += "<tr><th>날짜</th><td>"+result.board.register+"</td></tr>"
			    content += "<tr><th>내용</th><td>"+result.content+"</td></tr>"							
			    content += "<tr><td colspan=2 align=center>"							
			    content += "<input type=button value=수정  onclick='updateform("+result.board.no+","+page+")'>"							
			    content += "<input type=button value=삭제  onclick='deleteform("+result.board.no+","+page+")'>"							
			    content += "</td></tr></table>"							
			
			$("#detail").html(content);
		}			
	});		
}

// 수정폼
function updateform(no, page){
	alert("수정폼");
	$("#detail").hide();
	$("#updateform").show();
	
	$.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/board/updateform/"+no+"/"+page,
		success : function(result){
			
			var content = "<form id='myupdate'><table border=1>"
			    content += "<input type=hidden id=no2 name=no value="+result.board.no+">"
			    content += "<tr><th>번호</th><td>"+result.board.no+"</td></tr>"
			    content += "<tr><th>작성자</th><td><input type=text id=writer2 name=writer value="+result.board.writer+"></td></tr>" 
			    content += "<tr><th>비밀번호</th><td><input type=text id=passwd2 name=passwd></td></tr>" 
			    content += "<tr><th>제목</th><td><input type=text id=subject2 name=subject value="+result.board.subject+"></td></tr>"
			    content += "<tr><th>내용</th><td><input type=text id=content2 name=content value="+result.board.content+"></td></tr>"							
			    content += "<tr><td colspan=2 align=center>"							
			    content += "<input type=button value=수정  onClick='update("+page+")'>"							
			    content += "</td></tr></table></form>"							
			
			$("#updateform").html(content);
		}			
	});		
	
}

// 글수정
function update(page){
	alert("글수정");
	
	var formData = {
	        no: $("#no2").val(), 			
	        writer: $("#writer2").val(),
	        passwd: $("#passwd2").val(),
	        subject: $("#subject2").val(),
	        content: $("#content2").val()
	    };
	
	$.ajax({
		type : "PUT",
		url : "${pageContext.request.contextPath}/board/boardupdate/"+page,
		contentType: 'application/json',  			// 데이터 타입을 JSON으로 설정
		data : JSON.stringify(formData),  			// 데이터를 JSON 문자열로 변환하여 전송
		success : function(result){
			if(result == 1){
				alert("수정성공");
			}else{
				alert("수정실패");
			}
			boardlist(page);  						// 글수정후 목록 페이지로 이동
		}	
	});	
}

//글삭제 폼
function deleteform(no, page){
	alert("삭제폼");
	$("#detail").hide();
	$("#deleteform").show();
	
	$.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/board/deleteform/"+no+"/"+page,
		success : function(result){
			
			var content = "<form id='mydelete'><table border=1>"
			    content += "<input type=hidden id=no3 name=no value="+result.no+">"
			    content += "<input type=hidden name=page value="+result.page+">"
			    content += "<tr><th>비밀번호</th><td><input type=text id=passwd3 name=passwd></td></tr>" 
			    content += "<tr><td colspan=2 align=center>"							
			    content += "<input type=button value=삭제  onClick='delete1("+page+")'>"							
			    content += "</td></tr></table></form>"							
			
			$("#deleteform").html(content);
		}			
	});		
}

//글삭제
function delete1(page){
	alert("글삭제");
	
	var formData = {
	        no: $("#no3").val(), 			
	        passwd: $("#passwd3").val(),
	    };
	
	$.ajax({
		type : "DELETE",
		url : "${pageContext.request.contextPath}/board/boarddelete/"+page,
		contentType: 'application/json',  			// 데이터 타입을 JSON으로 설정
		data : JSON.stringify(formData),  			// 데이터를 JSON 문자열로 변환하여 전송
		success : function(result){
			if(result == 1){
				alert("삭제성공");
			}else{
				alert("삭제실패");
			}
			boardlist(page);  						// 글삭제후 목록 페이지로 이동
		}	
	});	
}
</script>
</head>
<body>

<form>
	<input type="button" id="write" value="글작성">
	<input type="button" id="list" value="글목록">
	<input type="button" id="update" value="글수정">
	<input type="button" id="delete" value="글삭제">
</form>

<!-- 글작성 폼 -->
<div id="writeform"></div>

<!-- 글목록  -->
<table id="mytable" align="center" width=800>
	<tbody id="mytbody"></tbody>
</table>

<!-- 페이징 처리 -->
<div id="pagination"></div>

<!-- 상세 페이지 -->
<div id="detail"></div>

<!-- 수정폼 페이지 -->
<div id="updateform"></div>

<!-- 삭제폼 페이지 -->
<div id="deleteform"></div>

</body>
</html>