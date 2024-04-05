#include <stdio.h>
#include "stdlib.h"
#include <string.h>
#include "tree.h"
#include "parser.h"


extern FILE* yyin;
extern int yyparse();
extern int tree;
extern void printHelp();


int execution(char *filename, int printT){
    if (filename != NULL) {
        FILE *file = freopen(filename, "r", stdin);
        if (file == NULL) {
            fprintf(stderr, "Error opening file");
            return 1;
        }
      }
    if (printT) {      // Si l'option -t est activée, on affiche l'arbre abstrait et on quitte
        tree = 1;
        yyparse();
    } else {
        int parseResult = yyparse();
        if (parseResult == 0) {
            fprintf(stdout, "Expression correcte\n");
        } else {
            return parseResult;
        }
    }
    return 0;
}

int main(int argc, char *argv[]) {
    char *filename = NULL;
    int printT = 0;
    if (argc > 1) {
        if (strcmp(argv[1], "--tree") == 0 || strcmp(argv[1], "-t") == 0) {
            printT = 1;
            filename = (argc > 2) ? argv[2] : NULL;
        } else if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0) {
            printHelp();
            return 0;
        } else {
            fprintf(stderr, "Usage: %s [--tree] [--help] [FILE.tpc]\n", argv[0]);
            return 1;
        }
        if (filename != NULL) {
            int len = strlen(filename);
            if (len < 4 || strcmp(filename + len - 4, ".tpc") != 0) {
                fprintf(stderr, "Le fichier doit avoir l'extension .tpc\n");
                return 1;
            }
        }
    }
    return execution(filename, printT);
}
