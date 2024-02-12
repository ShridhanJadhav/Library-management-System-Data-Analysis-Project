create DATABASE LIBRARY_DA;
CREATE TABLE authors(
    book_authors_AuthorId INT AUTO_INCREMENT,
    book_authors_BookId INT,
    book_authors_AuthorName varchar(255),
    PRIMARY KEY (book_authors_AuthorId),
    FOREIGN KEY(book_authors_BookId) REFERENCES book(book_BookID)  ON UPDATE CASCADE on delete cascade
) ENGINE=InnoDB CHARSET=latin1;

CREATE TABLE bookcopies(
    book_copies_CopiesID INT AUTO_INCREMENT,
    book_copies_BookID INT,
    book_copies_BranchID INt,
    book_copies_No_Of_Copies INT,
    PRIMARY KEY (book_copies_CopiesID),
    FOREIGN KEY(book_copies_BookID) REFERENCES book(book_BookID)  ON UPDATE CASCADE on delete cascade,
    FOREIGN KEY(book_copies_BranchID) REFERENCES librarybranch(library_branch_BranchID)  ON UPDATE CASCADE on delete cascade
    
) ENGINE=InnoDB CHARSET=latin1;

CREATE TABLE bookloans(
    book_loans_LoanID INT AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INt,
    book_loans_CardNo INT,
    book_loans_DateOut varchar(255),
    book_loans_DueDate varchar(255),
    PRIMARY KEY (book_loans_LoanID),
    FOREIGN KEY(book_loans_BookID) REFERENCES book(book_BookID)  ON UPDATE CASCADE on delete cascade,
    FOREIGN KEY(book_loans_BranchID) REFERENCES librarybranch(library_branch_BranchID)  ON UPDATE CASCADE on delete cascade,
    FOREIGN KEY(book_loans_CardNo) REFERENCES borrower(borrower_CardNo)  ON UPDATE CASCADE on delete cascade
    
) ENGINE=InnoDB CHARSET=latin1;

CREATE TABLE book(
    book_BookID INT AUTO_INCREMENT,
    book_Title varchar(255),
    book_PublisherName varchar(255),
    PRIMARY KEY (book_BookID),
    FOREIGN KEY(book_PublisherName) REFERENCES publisher(publisher_PublisherName)  ON UPDATE CASCADE on delete cascade
) ENGINE=InnoDB CHARSET=latin1;

CREATE TABLE borrower(
    borrower_CardNo INT AUTO_INCREMENT,
    borrower_BorrowerName varchar(255),
    borrower_BorrowerAddress varchar(255),
    borrower_BorrowerPhone varchar(255),
    PRIMARY KEY (borrower_CardNo)
) ENGINE=InnoDB CHARSET=latin1;

CREATE TABLE librarybranch(
    library_branch_BranchID INT AUTO_INCREMENT,
    library_branch_BranchName varchar(255),
	library_branch_BranchAddress varchar(255),
    PRIMARY KEY (library_branch_BranchID)
) ENGINE=InnoDB CHARSET=latin1;

CREATE TABLE publisher(
    publisher_PublisherName varchar(255),
    publisher_PublisherAddress varchar(255),
	publisher_PublisherPhone varchar(255),
    PRIMARY KEY (publisher_PublisherName)
) ENGINE=InnoDB CHARSET=latin1;



/* 1.  How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?*/

select book_Title,library_branch_BranchName,book_copies_No_Of_Copies from bookcopies
inner join book on bookcopies.book_copies_BookID=book.book_BookID inner join 
librarybranch on bookcopies.book_copies_BranchID=librarybranch.library_branch_BranchID 
where book_Title="The Lost Tribe" and library_branch_BranchName="Sharpstown";

/* 2.  How many copies of the book titled "The Lost Tribe" are owned by each library branch?*/

select book_Title,library_branch_BranchName,book_copies_No_Of_Copies from bookcopies inner join book 
on bookcopies.book_copies_BookID=book.book_BookID inner join 
librarybranch on bookcopies.book_copies_BranchID=librarybranch.library_branch_BranchID 
where book_Title="The Lost Tribe" ;

/* 3.  Retrieve the names of all borrowers who do not have any books checked out.*/

select distinct(borrower_BorrowerName) from borrower
WHERE NOT EXISTS (SELECT * FROM bookloans where borrower.borrower_CardNo=bookloans.book_loans_CardNo);

/* 4.  For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
retrieve the book title, the borrower's name, and the borrower's address. */

select book_Title,borrower_BorrowerName,borrower_BorrowerAddress from librarybranch inner join bookloans 
on librarybranch.library_branch_BranchID = bookloans.book_loans_BranchID inner join book 
 on bookloans.book_loans_BookID = book.book_BookID inner join borrower on borrower.borrower_CardNo = bookloans.book_loans_CardNo
 where book_loans_DueDate="2/3/18" and library_branch_BranchName="Sharpstown" ;

/* 5.  For each library branch, retrieve the branch name and the total number of books loaned out from that branch.*/

select library_branch_BranchName, COUNT(*) from librarybranch 
inner join bookloans on librarybranch.library_branch_BranchID=bookloans.book_loans_BranchID
Group by library_branch_BranchName;

/* 6.  Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.*/

SELECT B.borrower_BorrowerName, B.borrower_BorrowerAddress, COUNT(*)
FROM  borrower B, bookloans L
WHERE  B.borrower_CardNo = L.book_loans_CardNo
GROUP BY  B.borrower_CardNo, B.borrower_BorrowerName, B.borrower_BorrowerAddress
HAVING  COUNT(*) > 5;

/* 7.  For each book authored by "Stephen King", retrieve the title and 
the number of copies owned by the library branch whose name is "Central".*/

SELECT distinct(book_Title), book_copies_No_Of_Copies 
FROM   (((authors NATURAL JOIN book) NATURAL JOIN 
bookcopies) NATURAL JOIN librarybranch)WHERE 
book_authors_AuthorName='Stephen King' AND library_branch_BranchName='Central';


