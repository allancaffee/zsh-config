/*
 * svn-verbose-editor - Edittor for Subversion log messages
 * Copyright (C) 2008 Allan Michael Caffee <acaffee@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA
 */

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

static const char *
SVN_END_LOG_MESSAGE = "--This line, and those below, will be ignored--\n";

char * EDITOR = "vim";

struct linked_list {
  char filename[FILENAME_MAX];
  struct linked_list * next;
};
typedef struct linked_list linked_list;

/** A pointer to the list of filenames.  */
linked_list * FileListHead = 0;
char * MessageFileName = 0;

void build_file_list (FILE * input);
void destroy_file_list (void);
void chomp (char * s);
void append_diffs (FILE * output);
void process_input (FILE * input, FILE * output);
short is_directory (const char * filename);

int
main (int argc, char* argv [])
{
  FILE * input, * output;
  char * filename;
  int numfiles;

  if (argc < 2)
    {
      char * const new_argv[] = {EDITOR, NULL};
      execvp (EDITOR, new_argv);
    }

  filename = argv[1];
  input = fopen (filename, "r");

  char * buf = malloc (sizeof(char) * BUFSIZ);
  while (buf = fgets (buf, BUFSIZ, input))
    {
      if (strcmp (SVN_END_LOG_MESSAGE, buf) == 0)
        build_file_list (input);
    }
  free (buf);
  fclose (input);

  /* If the file list was empty just edit the file.  */
  if (!FileListHead)
    {
      fprintf (stderr, "Empty file list!\n");
      char * const new_argv[] = {EDITOR, NULL};
      execvp (EDITOR, new_argv);
    }
    
  output = fopen (filename, "ab");
  append_diffs (output);
  fclose (output);
  destroy_file_list ();

  char * const new_argv[] = {EDITOR, filename,
                             "-c", "set filetype=diff",
                             "+0", NULL};
  execvp (EDITOR, new_argv);
  
  return 0;
}

void
append_diffs (FILE * out)
{
  FILE * input;
  const int COMMAND_LEN = FILENAME_MAX + 9;
  char* command = malloc (sizeof(char) * COMMAND_LEN);

  linked_list * current = FileListHead;

  /* Add an empty line for clarity.  */
  fprintf (out, "\n");

  while (current)
    {
      sprintf (command, "svn diff %s", current->filename);

      input = popen (command, "r");
      process_input (input, out);
      pclose (input);
      current = current->next;
    }
  free (command);
}

void
destroy_file_list (void)
{
  linked_list * current = FileListHead;
  linked_list * prev;

  while (current) {
    prev = current;
    current = current->next;
    free (prev);
  }
}

/**
 * @post Everything in @a input until the EOF shall been read.
 *
 * @post The global variable FileList will contain the file names of
 * all files which should be diffed.
 */
void
build_file_list (FILE * input)
{
  linked_list * current = 0;
  linked_list * temp = 0;
  char * buf = malloc (sizeof(char) * BUFSIZ);
  const char * cur;

  while (buf = fgets (buf, BUFSIZ, input))
    {
      chomp (buf);
      switch (buf[0]) {
      case 'M':
      case 'A':
      case 'D':
        /* Iterate through the characters until the first
           non-whitespace.  */
        cur = (const char *) buf + 2;
        while (*cur != '\0' && isspace (*cur))
          ++cur;

        if (!is_directory (cur))
          {
            temp = malloc (sizeof (linked_list));
            strncpy (temp->filename, cur, FILENAME_MAX);
            temp->next = 0;
            if (current)
              current->next = temp;
            if (!FileListHead)
              FileListHead = temp;
            current = temp;
          }
      }
    }
  free (buf);
}

void
chomp (char * s)
{
  size_t length = strlen (s);
  if (s[length - 1] == '\n')
    s[length - 1] = '\0';
}

void
process_input (FILE * input, FILE * output)
{
  int c;

  while ((c = getc (input)) != EOF)
    {
      if (isascii (c))
        fprintf(output, "%c", c);
      else
        fprintf (output, "\\%o", c);
    }
}

short
is_directory (const char * filename)
{
  struct stat m;
  stat (filename, &m);
  return (S_ISDIR (m.st_mode));
}
