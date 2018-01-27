class Link {
  int x, y;
  Link next;
  
  Link(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

class LinkedList {
  private Link head, last;
  
  LinkedList() {
    head = last = new Link(0, 0);
  }
  
  LinkedList(Link l) {
    this();
    append(l);
  }
  
  Link first() {
    return head.next;
  }
  
  void append(Link l) {
    last.next = l;
    last = l;
  }
  
  Link removeFirst() {
    Link l = head.next;
    head.next = head.next.next;
    return l;
  }
  
  int length() {
    Link l = first();
    int k = 0;
    for( ; l != null; l = l.next, k++) {}
    return k;
  }
}
