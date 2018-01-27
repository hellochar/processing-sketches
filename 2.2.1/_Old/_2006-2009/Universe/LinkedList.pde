/* Linked List
  Version 1.0, programmed by Jill Jackson
  
  Take my LinkedList class if you want. I'm pretty sure it's not the fastest or the best there is out there, but it works for me
*/

public class Link {

    public Link next;
    public Object data;

    public Link(Link next, Object data) {
        this.next = next;
        this.data = data;
    }

    public Link(Object data) {
        this(null, data);
    }
}


public class LinkedList {

    final Link head = new Link(null);
    Link last = head;
    
    public LinkedList() {
    }

    public LinkedList(Link l) {
        add(l);
    }

    public LinkedList(Object o) {
        this(new Link(o));
    }
//
//    public LinkedList(E[] array) {
//        for (E o : array) {
//            add(o);
//        }
//    }

    public Link first() {
        return head.next;
    }

    public void add(Link l) {
        last.next = l;
        last = l;
    }

    public void add(Object a) {
        add(new Link(a));
    }
    
    public void insert(Link l, int index) {
        Link linkAt = linkAt(index-1), next = linkAt.next;
        linkAt.next = l;
        l.next = next;
        if(next == null) last = l;
    }
    
    public void insert(Object o, int index) {
        insert(new Link(o), index);
    }

    public Link linkAt(int index) {
        Link current = head;
        for (int a = -1; a < index; a++) {
            if (current == null) {
                break;
            } else {
                current = current.next;
            }
        }
        return current;
    }

    public void remove(int index) {
        Link prev = linkAt(index - 1);
        if((prev.next = prev.next.next) == null)
            last = prev.next;
    }

    public int remove(Link l) {
        Link current = head;
        for (int a = -1; current != null; a++, current = current.next) {
            if (current.next == l) {
                if((current.next = l.next) == null) last = current;
                return a;
            }
        }
        return -1;
    }

    public int remove(Object o) {
        Link current = head;
        for (int a = -1; current != null; a++, current = current.next) {
            if (current.next.data == o) {
                if((current.next = current.next.next) == null) last = current;
                return a;
            }
        }
        return -1;
    }

    public int indexOf(Link l) {
        Link current = head;
        for (int a = -1; current != null; a++, current = current.next) {
            if (current == l) {
                return a;
            }
        }
        return -1;
    }

    public int indexOf(Object e) {
        Link current = head;
        for (int a = -1; current != null; a++, current = current.next) {
            if (current.data == e) {
                return a;
            }
        }
        return -1;
    }

    public String toString() {
        Link l = first();
        String s = super.toString();
        for (int a = 0; l != null; a++) {
            s += "\n[" + a + "]" + l.data;
            l = l.next;
        }
        return s;
    }

    public Object[] toArray() {
        Object[] list = new Object[length()];
        Link current = first();
        for (int b = 0; b < list.length; b++) {
            list[b] = current.data;
            current = current.next;
        }
        return list;
    }

    public int length() {
        Link current = first();
        int a = 0;
        for(; current != null; a++, current = current.next) {}
        return a;
    }
}
