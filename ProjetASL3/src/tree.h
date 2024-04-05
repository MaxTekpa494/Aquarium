/* tree.h */

typedef enum {
    program,
    declvars,
    declarations,
    declfoncts,
    declfonct,
    entetefonct,
    parametres,
    listtypvar,
    tableparametre,
    afterparam,
    corps,
    suiteinstr,
    instr,
    exp,
    tb,
    fb,
    m,
    e,
    t,
    f,
    type,
    id,
    num,
    byte,
    comp,
    lvalue,
    charac,
    argument
} label_t;


typedef struct Node {
  label_t label;
  struct Node *firstChild, *nextSibling;
  int linero;
  union {
    char byte;  // Reconnait "+", "-", "%", "*", "/"
    int num;
    char ident[64];
    char comp[2]; // Reconnait "==", "!=", "&&", "||"
    char charac[5];  // Reconnait les caractères litteraux
    char type[4];  // Reconnait "int, void, char ..." 
  } data;
} Node;


Node *makeNode(label_t label);
void addSibling(Node *node, Node *sibling);
void addChild(Node *parent, Node *child);
void deleteTree(Node*node);
void printTree(Node *node);

#define FIRSTCHILD(node) node->firstChild
#define SECONDCHILD(node) node->firstChild->nextSibling
#define THIRDCHILD(node) node->firstChild->nextSibling->nextSibling
