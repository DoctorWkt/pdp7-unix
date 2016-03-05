package com.khubla.pdp7parse;

/*
* Copyright 2016, Tom Everett <tom@khubla.com>
*
*   This program is free software: you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation, either version 3 of the License, or
*   (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Collection;

import org.apache.commons.io.FileUtils;
import org.testng.Assert;
import org.testng.annotations.Test;

import com.khubla.pdp7parse.antlr4.pdp7Parser.ProgContext;

public class BasicTests {
   @Test
   public void test1() {
      String[] extensions = new String[] { "s" };
      Collection<File> files = FileUtils.listFiles(new File("src/test/resources"), extensions, true);
      for (File file : files) {
         testFile(file);
      }
   }

   private void testFile(File file) {
      try {
         System.out.println(file.getAbsolutePath());
         InputStream is = new FileInputStream(file);
         ProgContext progContext = PDP7Parser.parse(is, System.out);
         Assert.assertNotNull(progContext);
      } catch (Exception e) {
         e.printStackTrace();
         Assert.fail();
      }
   }
}
