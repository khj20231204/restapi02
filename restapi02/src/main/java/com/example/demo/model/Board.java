package com.example.demo.model;

import java.util.Date;
import org.apache.ibatis.type.Alias;
import lombok.Data;

@Data
@Alias("board")
public class Board {
	private int no;
	private String writer;
	private String passwd;
	private String subject;
	private String content;
	private int readcount;
	private Date register;
	
}
