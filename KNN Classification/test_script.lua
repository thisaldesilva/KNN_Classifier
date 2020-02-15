-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )
print("TEST SEQUENCE INITIATED")
luaunit = require('luaunit')
knn = require('knn')

function round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
  end


TestFunctions = {}
    function TestFunctions:testEuclidean()
		luaunit.assertEquals(round(euclideanDistanceResolver(0, 0, 4, 3),3),5)
		luaunit.assertEquals(round(euclideanDistanceResolver(0.2, 0.2, 1, 3),3),2.912)
		luaunit.assertEquals(round(euclideanDistanceResolver(1, 1, 3, 3),3),2.828)
		luaunit.assertEquals(round(euclideanDistanceResolver(9, 9, 3, 7),3),6.325)
		luaunit.assertEquals(round(euclideanDistanceResolver(9.8, 9.8, 7, 4),3),6.44)
		luaunit.assertEquals(round(euclideanDistanceResolver(10 ,10, 4, 1),3),10.817)
		luaunit.assertEquals(round(euclideanDistanceResolver(11, 11, 7, 4),3),8.062)
		luaunit.assertEquals(round(euclideanDistanceResolver(50 ,50, 4, 1),3),67.209)
		luaunit.assertEquals(round(euclideanDistanceResolver(-50 ,-50, 4, 1),3),74.277)
	end

	
    function TestFunctions:testManhattan()
		luaunit.assertEquals(round(manhattanDistanceResolver(0, 0, 4, 3),3),7)
		luaunit.assertEquals(round(manhattanDistanceResolver(0.2, 0.2, 1, 3),3),3.6)
		luaunit.assertEquals(round(manhattanDistanceResolver(1, 1, 3, 3),3),4)
		luaunit.assertEquals(round(manhattanDistanceResolver(9, 9, 3, 7),3),8)
		luaunit.assertEquals(round(manhattanDistanceResolver(9.8, 9.8, 7, 4),3),8.6)
		luaunit.assertEquals(round(manhattanDistanceResolver(10 ,10, 4, 1),3),15)
		luaunit.assertEquals(round(manhattanDistanceResolver(11, 11, 7, 4),3),11)
		luaunit.assertEquals(round(manhattanDistanceResolver(50 ,50, 4, 1),3),95)
		luaunit.assertEquals(round(manhattanDistanceResolver(-50 ,-50, 4, 1),3),105)
	end

	
    function TestFunctions:testCosine()
		--luaunit.assertEquals(round(cosineSimilarityResolver(0, 0, 4, 3),3),5)
		luaunit.assertEquals(round(cosineSimilarityResolver(0.2, 0.2, 1, 3),3),0.894)
		luaunit.assertEquals(round(cosineSimilarityResolver(1, 1, 3, 3),3),1)
	 	luaunit.assertEquals(round(cosineSimilarityResolver(9, 9, 3, 7),3),0.928)
	 	luaunit.assertEquals(round(cosineSimilarityResolver(9.8, 9.8, 7, 4),3),0.965)
	 	luaunit.assertEquals(round(cosineSimilarityResolver(10 ,10, 4, 1),3),0.857)
	 	luaunit.assertEquals(round(cosineSimilarityResolver(11, 11, 7, 4),3),0.965)
	 	luaunit.assertEquals(round(cosineSimilarityResolver(50 ,50, 4, 1),3),0.857)
	 	luaunit.assertEquals(round(cosineSimilarityResolver(-50 ,-50, 4, 1),3),-0.857)
		end

	
    function TestFunctions:testChebyshev()
		luaunit.assertEquals(round(chebyshevDistanceResolver(0, 0, 4, 3),3),4)
		luaunit.assertEquals(round(chebyshevDistanceResolver(0.2, 0.2, 1, 3),3),2.8)
		luaunit.assertEquals(round(chebyshevDistanceResolver(1, 1, 3, 3),3),2)
		luaunit.assertEquals(round(chebyshevDistanceResolver(9, 9, 3, 7),3),6)
		luaunit.assertEquals(round(chebyshevDistanceResolver(9.8, 9.8, 7, 4),3),5.8)
		luaunit.assertEquals(round(chebyshevDistanceResolver(10 ,10, 4, 1),3),9)
		luaunit.assertEquals(round(chebyshevDistanceResolver(11, 11, 7, 4),3),7)
		luaunit.assertEquals(round(chebyshevDistanceResolver(50 ,50, 4, 1),3),49)
		luaunit.assertEquals(round(chebyshevDistanceResolver(-50 ,-50, 4, 1),3),54)
	end
--end of test functions

os.exit( luaunit.LuaUnit.run() )