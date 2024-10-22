package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import com.example.demo.model.Board;

@Mapper
public interface BoardDao {

	public int insert(Board board);

	public int getCount();

	public List<Board> getBoardList(int page);

	public void updatecount(int no);

	public Board getBoard(int no);

	public int update(Board board);

	public int delete(int no);

}
