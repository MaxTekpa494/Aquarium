/* tree.c */
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
extern int linero;       /* from lexer */



static const char *StringFromLabel[] = {
    "program",
    "declvars",
    "declarateurs",
    "declfoncts",
    "declfonct",
    "entetefonct",
    "parametres",
    "listtypvar",
    "tableparametre",
    "afterparam",
    "corps",
    "suiteinstr",
    "instr",
    "exp",
    "tb",
    "fb",
    "m",
    "e",
    "t",
    "f",
    "type",
    "id",
    "num",
    "byte",
    "comp",
    "lvalue",
    "charac",
    "argument"
};


Node *makeNode(label_t label) {
  Node *node = malloc(sizeof(Node));
  if (!node) {
    printf("Run out of memory\n");
    exit(1);
  }
  node->label = label;
  node-> firstChild = node->nextSibling = NULL;
  node->linero=linero;
  return node;
}

void addSibling(Node *node, Node *sibling) {
  Node *curr = node;
  while (curr->nextSibling != NULL) {
    curr = curr->nextSibling;
  }
  curr->nextSibling = sibling;
}

void addChild(Node *parent, Node *child) {
  if (parent->firstChild == NULL) {
    parent->firstChild = child;
  }
  else {
    addSibling(parent->firstChild, child);
  }
}

void deleteTree(Node *node) {
  if (node->firstChild) {
    deleteTree(node->firstChild);
  }
  if (node->nextSibling) {
    deleteTree(node->nextSibling);
  }
  free(node);
}

void printTree(Node *node) {
  static bool rightmost[128]; // tells if node is rightmost sibling
  static int depth = 0;       // depth of the current node
  for (int i = 1; i < depth; i++) { // 2502 = vertical line
    printf(rightmost[i] ? "    " : "\u2502   ");
  }
  if (depth > 0) { // 2514 = L form; 2500 = horizontal line; 251c = vertical line and right horiz
    printf(rightmost[depth] ? "\u2514\u2500\u2500 " : "\u251c\u2500\u2500 ");
  }
  switch (node->label) {
    case type:
      printf("%s", node->data.type);
      break;
    case id:
      printf("%s", node->data.ident);
      break;
  	case num:
      printf("%d", node->data.num);
      break;
    case byte:
      printf("%c", node->data.byte);
      break;
  	case charac:
      printf("%s", node->data.charac);
      break;
    case comp:
      printf("%s", node->data.comp);
      break;
    default:
      printf("%s", StringFromLabel[node->label]);
      break;
  }
  printf("\n");

  depth++;
  for (Node *child = node->firstChild; child != NULL; child = child->nextSibling) {
    rightmost[depth] = (child->nextSibling) ? false : true;
    printTree(child);
  }
  depth--;
}
