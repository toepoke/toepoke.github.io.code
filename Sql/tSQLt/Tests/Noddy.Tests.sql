exec tSQLt.NewTestClass 'Noddy_Tests';
go

create procedure [Noddy_Tests].[Test #01) - 2 + 2 does indeed equal 4]
as
begin
	declare @actual int = null;
	declare @two int = null;
	
	-- Arrange
	set @two = 2;

	-- Act
	set @actual = (@two + @two);

	-- Assert
	exec tSQLt.AssertEquals 4, @actual;

end
go

exec tSQLt_Helpers.Run 'Noddy_Tests', 1;
go

exec tSQLt.DropClass 'Noddy_Tests';
go

