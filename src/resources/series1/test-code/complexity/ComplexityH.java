public class ComplexityH {
	
	void test(String[] args)
    {
		//Complexity 1
        do {
        	args[0] += "t";
        } while(args[0].compareTo("test") == 0);
                
      //Complexity 5
        switch(args[0]) {
	        case "test":
	    		args[0] += "t";
	    		break;
	        case "tes1t":
	    		args[0] += "t";
	    		break;
	        case "test2":
	    		args[0] += "t";
	    		break;
	        case "test3":
	    		args[0] += "t";
	    		break;
	        case "test4":
	    		args[0] += "t";
	    		break;
    		default:
    			args[0] += "t";
        		break;	
        }
    }
}
