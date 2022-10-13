//DOUBLY LINKED LIST CODE
public class DoublyLinkedList<E>
{
  ListNode front;
  ListNode end;
  ListNode curr;
  int numElements;
  
  //Checks if the linked list is empty
  public boolean isEmpty()
  {
    return numElements == 0;
  }

  //Adds an item to the front of the linked list
  public void addFront(E data)
  {
    front = new ListNode(null, data, front);

    if (front.next != null)
      front.next.prev = front;

    numElements++;

    if (numElements == 1)
      end = front;
  }

  //Adds an item to the end of the linked list
  public void addLast(E data)
  {
    if (numElements == 0)
    {
      addFront(data);
      return;
    }

    ListNode curr = end;
    curr.next = new ListNode(curr, data, null);
    end = curr.next;
    numElements++;
  }

  //REPRESENTS ONE NODE IN THE LIST WITH ACCESS TO NEXT AND LAST NODE
  public class ListNode
  {
    private ListNode prev, next;
    private E data;

    public ListNode(ListNode p, E d, ListNode n)
    {
      prev = p;
      data = d;
      next = n;
    }
  }
}
