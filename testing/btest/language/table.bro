# @TEST-EXEC: bro %INPUT >out
# @TEST-EXEC: btest-diff out

function test_case(msg: string, expect: bool)
        {
        print fmt("%s (%s)", msg, expect ? "PASS" : "FAIL");
        }


event bro_init()
{
	local t1: table[count] of string = table( [5] = "test", [0] = "example" );
	local t2: table[count] of string = table();
	local t3: table[count] of string;
	local t4 = table( [1] = "type inference" );
	local t5: table[count] of string = { [1] = "curly", [3] = "braces" };
	local t6: table[port, string, bool] of string = table(
			 [1/tcp, "test", T] = "test1",
			 [2/tcp, "example", F] = "test2" );
	local t7: table[port, string, bool] of string = table();
	local t8: table[port, string, bool] of string;
	local t9 = table( [8/tcp, "type inference", T] = "this" );
	local t10: table[port, string, bool] of string = { 
		[10/udp, "curly", F] = "first",
		[11/udp, "braces", T] = "second" };

	# Test the size of each table
	test_case( "cardinality", |t1| == 2 );
	test_case( "cardinality", |t2| == 0 );
	test_case( "cardinality", |t3| == 0 );
	test_case( "cardinality", |t4| == 1 );
	test_case( "cardinality", |t5| == 2 );
	test_case( "cardinality", |t6| == 2 );
	test_case( "cardinality", |t7| == 0 );
	test_case( "cardinality", |t8| == 0 );
	test_case( "cardinality", |t9| == 1 );
	test_case( "cardinality", |t10| == 2 );

	# Test iterating over each table
	local ct: count;
	ct = 0;
	for ( c in t1 )
	{
		if ( type_name(c) != "count" )
			print "Error: wrong index type";
		if ( type_name(t1[c]) != "string" )
			print "Error: wrong table type";
		++ct;
	}
	test_case( "iterate over table", ct == 2 );

	ct = 0;
	for ( c in t2 )
	{
		++ct;		
	}
	test_case( "iterate over table", ct == 0 );

	ct = 0;
	for ( c in t3 )
	{
		++ct;		
	}
	test_case( "iterate over table", ct == 0 );

	ct = 0;
	for ( [c1, c2, c3] in t6 )
	{
		++ct;		
	}
	test_case( "iterate over table", ct == 2 );

	ct = 0;
	for ( [c1, c2, c3] in t7 )
	{
		++ct;		
	}
	test_case( "iterate over table", ct == 0 );

	# Test adding elements to each table
	t1[1] = "added";
	test_case( "add element", |t1| == 3 );
	test_case( "in operator", 1 in t1 );

	t2[11] = "another";
	test_case( "add element", |t2| == 1 );
	t2[0] = "test";
	test_case( "add element", |t2| == 2 );
	test_case( "in operator", 11 in t2 );
	test_case( "in operator", 0 in t2 );

	t3[3] = "foo";
	test_case( "add element", |t3| == 1 );
	test_case( "in operator", 3 in t3 );

	t4[4] = "local";
	test_case( "add element", |t4| == 2 );
	test_case( "in operator", 4 in t4 );

	t5[10] = "local2";
	test_case( "add element", |t5| == 3 );
	test_case( "in operator", 10 in t5 );

	# Note: cannot add elements to tables of multiple types

	# Test removing elements from each table
	delete t1[0];
	delete t1[17];  # element does not exist
	test_case( "remove element", |t1| == 2 );
	test_case( "!in operator", 0 !in t1 );

	delete t2[0];
	test_case( "remove element", |t2| == 1 );
	test_case( "!in operator", 0 !in t2 );

	delete t3[3];
	test_case( "remove element", |t3| == 0 );
	test_case( "!in operator", 3 !in t3 );

	delete t4[1];
	test_case( "remove element", |t4| == 1 );
	test_case( "!in operator", 1 !in t4 );

	delete t5[1];
	test_case( "remove element", |t5| == 2 );
	test_case( "!in operator", 1 !in t5 );

	# Note: cannot remove elements from tables of multiple types

}

