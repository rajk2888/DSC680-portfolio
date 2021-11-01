# DSC-680-Portfolio 
# Web Scraping

For this portfolio, I want to showcase a data journey. The beginning of the journey should 
start with the acquisition of data. Thus, the file DSC 540 Final Chase Lemons is a Jupyter Notebook
that has a workflow to capture data from IMDB to generate a list of the newest movies that have been released.

### The requirements for the exercise included:
* Your formatted dataset with at least 15-20 variables (if the API or Webpage you selected doesn’t have that many fields available on it, you will want to search again, or do multiple!)
* Your code or screenshots of your code outlining the steps and process you had to take to pull data from the API or web page and the steps you took to format the data.
* 2 Data Transformation/Clean-up Steps (can be any that we learned in class)

### Summary
To begin, I chose the IMDB new movies list to scrape because there was enough content to scrape and get multiple records from it. The other reason, is because I love movies and tv. So I broke the final into two sections. Identifying and getting the items from the page that I wanted. Then for the second portion, was putting the data into a format that could be used.

For the first section, I started by inspecting the elements of the page. The first road block came when I was trying to pull the links for some of these items. This was a little difficult but once I added another for loop searching just for the "a" element and then the href underneath that, it became easy. The second road block came from the director versus stars group. They sit under the same div, so pulling out the directors was easy but then specifying the stars was a bit more difficult. I was ultimately able to replace the span element and include the stars by comparing the stars list to the director list and only appending that list to the overall list if it didn't match or wasn't empty.

For the second section, I had all of these lists, but for 3 of the items, they were on some of the movies but not all of them. So I added most of the items in the lists to dictionaries and then put them in a list. For the final 3 items, I put them in their own list of dictionaries with the title and the item themselves so I could then do a left join to the first list of dictionaries. Thus, the last 3 columns added to the overall data frame have some nulls but have values for the movies that had these fields.

In the previous paragraph I point out that I did a left join data transformation. The second transformation/cleaning that I did was throughout using strip(),lower(), or splitting fields with ; and pulling out the pieces that I needed. Thus, cleaning the data and prepping it for joining.

As a data scientist looking at this, I could run this script weekly whenever the page updates for the new weeks list of movies. Once I knew when this list gets updated, I could schedule this job to run to pull this data. If the web developers for this page changed it however, I would need to revisit my code in order to update any changes and to ensure it is pulling the right data.
