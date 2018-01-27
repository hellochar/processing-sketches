Class<Integer> c = Integer.TYPE;
Integer i = new Integer(6);
println("c: "+c+", i: "+i.getClass());
Integer j = c.cast(i);
println(i+", "+j);
