# Allen Black and Nicholas Vitha
# Rooming Help Gonzaga
# CPSC 326 Organization of Programming Languages
# See readme.txt for running instructions

# Strict and warnings are recommended.
use strict;
use warnings; 
	
sub userInput{ #used to figure out if the person is renting or leasing
	my $validchoice = 0;
	while(not $validchoice){ #used to control whether the user has decided properly
		print "Are you looking for a house? (Type \"y\" or \"yes\" for yes or \"n\" or \"no\" for no.)\n";
		my $choice = <>; #takes user input
		print ("--------------------------------------------\n"); #used to separate program writing to console and user writing to console 
		if($choice eq "yes\n" || $choice eq "y\n"){ #if yes
			$validchoice = 1;
			lookingForHouse();#call renter function
		} elsif($choice eq "no\n" || $choice eq "n\n") {#if no
			$validchoice = 1;
			haveAHouse();#call leaser function
		} else {
			print("I am sorry, that is not a valid choice.\n");#warn the user they are bad at typing
		}
	}
}

sub lookingForHouse{
	my $rentcorrect = 0; #used to figure out if the renter actually entered correct values for things
	my $rentname = "a";
	my $rentmaxrent = 0;
	my $rentminrent = 0;
	my $rentbedrooms = 0;
	my $rentbathrooms = 0;
	my $rentphonenumber = "1";

	
	while(not $rentcorrect){ #used to control if the renter says they used correct values
		print "Looking for Houses\n";
		print "What is your name?\n";
		$rentname = <>; 
		print ("--------------------------------------------\n");
		while(index($rentname,",") !=-1){#since we are using a CSV file, it is important that there are no stray commas
			print("It appears you have used a comma in your name. Please re-enter your street address without a comma.\n");
			$rentname = <>;
			print ("--------------------------------------------\n");			
		}
		
		print "What is your maximum rent per month? (No dollar signs or decimals.) (Set to 0 if you don't care)\n";
		$rentmaxrent = <>;
		print ("--------------------------------------------\n");
		$rentminrent = 0;
		if($rentmaxrent > 0){ #used if the user cares what the price of the housing is
			print "What is the minimum rent you are looking for? (No dollar signs or decimals)\n";
			$rentminrent = <>;
			print ("--------------------------------------------\n");	
			while($rentminrent >= $rentmaxrent){
				print("Your min rent must be higher than your max rent.\n Please re-enter your min rent.\n");
				$rentminrent = <>;
				print("--------------------------------------------\n");
			}
		} else { #used if the user does not care about the price of the housing
			$rentminrent = 0;
		}
		
		print "How many bedrooms are you looking for?\n";
		$rentbedrooms = <>;
		print ("--------------------------------------------\n");
		
		print "How many bathrooms are you looking for?\n";
		$rentbathrooms = <>;
		print ("--------------------------------------------\n");
		
		print "What is your phone number?\n";
		$rentphonenumber = <>;
		print ("--------------------------------------------\n");
		
		printf("Your name is %s",$rentname); #verify that everything given to us is correct
		printf("Your number is %s\n",$rentphonenumber);
		if($rentmaxrent == 0){
			printf("You do not care about the amount of rent per month\n");
		}else{
			printf("Your preferred rent is between \$%d/month and \$%d/month \n",$rentminrent,$rentmaxrent);
		}
		printf("You want to have %d bedrooms and %d bathrooms\n",$rentbedrooms,$rentbathrooms);
		
		my $rentyncorrect = 0;
		my $rentchoice2 = "a";
		while(not $rentyncorrect){#used to encapsulate a user choice
			print("Is all this information correct?(Type \"y\" or \"yes\" for yes or \"n\" or \"no\" for no.)\n");#verify correct information
			my $rentchoice2 = <>;
			if($rentchoice2 eq "yes\n" || $rentchoice2 eq "y\n"){#everything is correct
				$rentcorrect = 1;
				$rentyncorrect = 1;
			} elsif($rentchoice2 eq "no\n" || $rentchoice2 eq "n\n") {#not everything is correct
				$rentcorrect = 0;
				$rentyncorrect = 1;
			} else {
				print("I am sorry, that is not a valid choice.\n"); #not a valid choice, ask user again because they apparently can't type
			}
		}
	}
	
	open(my $data, '<', "landlords.csv") or die "Could not open file landlords.csv\n";
	my $rentcount = 0;
	
	
	while (my $line = <$data>) {
		chomp $line;
		
		my @fields = split "," , $line;
		if($rentmaxrent == 0){
			if($rentbedrooms <= $fields[4] and $rentbathrooms <= $fields[5]){
				printf("%s at %s has a house at %s with a rent of %d and %d bedrooms and %d bathrooms\n",$fields[0],$fields[1],$fields[2],$fields[3],$fields[4],$fields[5]);
				$rentcount = $rentcount + 1;
			}
		}
		else{
			if ($fields[3] > $rentminrent and $fields[3] < $rentmaxrent){
				if($rentbedrooms <= $fields[4] and $rentbathrooms <= $fields[5]){
					printf("%s at %s has a house at %s with a rent of %d and %d bedrooms and %d bathrooms\n",$fields[0],$fields[1],$fields[2],$fields[3],$fields[4],$fields[5]);
					$rentcount = $rentcount + 1;
				}
			}
		}
	}

	if ($rentcount == 0){ #if there were no matches
		print("There was no suitable housing found for you.\n However, your detaisl were added to our database.\n We will be in contact if somebody matches them.\n")
	} else {
		print("We have also added your details to our database.\n");
	}
	
	$rentname = substr($rentname, 0, -1);
	$rentphonenumber = substr($rentphonenumber,0,-1);
	$rentphonenumber = substr($rentphonenumber,0,-1);
	
	open (my $myrentfile, '>>', 'renters.csv') #open/create renter file in append mode
		or die "\nUnable to create/open renters.csv"; #fail if file cannot be created/opened
	printf $myrentfile "%s,%s,%d,%d,%d,%d\n",$rentname,$rentphonenumber,$rentminrent,$rentmaxrent,$rentbedrooms,$rentbathrooms;
	close $myrentfile;
}

sub haveAHouse{ #used for leasers/landlords
	my $landcorrect = 0;
	my $landname = "a";
	my $landnumber = "a";
	my $landprice = 0;
	my $landaddress = "a";
	my $landbedrooms = 0;
	my $landbathrooms = 0;
	
	while(not $landcorrect){#used to loop through until user verifies information is correct
		print "Looking for Renters\n";
		print "What is your name?\n";
		$landname = <>;
		print ("--------------------------------------------\n");
		while(index($landname,",") !=-1){#since we are using a CSV file, it is important that there are no stray commas
			print("It appears you have used a comma in your name. Please re-enter your street address without a comma.\n");
			$landname = <>;
			print ("--------------------------------------------\n");			
		}
		
		print "What is your phone number?\n";
		$landnumber = <>;
		print ("--------------------------------------------\n");
		
		print "How much are you charging per month?(No dollar signs or decimals)\n";#ask for monthly rate
		$landprice = <>;
		print ("--------------------------------------------\n");
			
		print "What is your street address? (Please do not use any commas)\n";
		$landaddress = <>;
		print ("--------------------------------------------\n");
		while(index($landaddress,",") !=-1){ #user used a comma in address
			print("It appears you have used a comma in your address. Please re-enter your street address without a comma.\n");
			$landaddress = <>;
			print ("--------------------------------------------\n");			
		}
		
		print "How many bedrooms are in this house?\n";
		$landbedrooms = <>;
		
		print ("--------------------------------------------\n");
		print "How many bathrooms are in this house?\n";
		$landbathrooms = <>;
		print ("--------------------------------------------\n");
		
		printf("Your name is %s",$landname);
		printf("Your number is %s",$landnumber);
		printf("You are charging \$%d/month in rent\n", $landprice);
		printf("Your address is %s", $landaddress);
		printf("Your house has %d bedrooms\n", $landbedrooms);
		printf("Your house has %d bathrooms\n", $landbathrooms);
		print("Is all this information correct?(Type \"y\" or \"yes\" for yes or \"n\" or \"no\" for no.)\n"); #ensure that everything entered is correct
		my $landchoice2 = <>;
		print ("--------------------------------------------\n");
		if($landchoice2 eq "yes\n" || $landchoice2 eq "y\n"){
			$landcorrect = 1;
		} elsif($landchoice2 eq "no\n" || $landchoice2 eq "n\n") {
			$landcorrect = 0;
		} else {
			print("I am sorry, that is not a valid choice.\n");
		}
	}
	
	open(my $data, '<', "renters.csv") or die "Could not open file renters.csv\n";
	my $landcount = 0;
	while (my $line = <$data>) {
		chomp $line;
		
		my @fields = split "," , $line;
		if($fields[3] == 0){
			if($landbedrooms >= $fields[4] and $landbathrooms >= $fields[5]){
				printf("%s at %s is looking for a house with a rent between \$%d/month and \$%d/month with %d bedrooms and %d bathrooms\n",$fields[0],$fields[1],$fields[2],$fields[3],$fields[4],$fields[5]);
				$landcount = $landcount + 1;
			}
		}
		else{
			if ($fields[2] < $landprice and $fields[3] > $landprice){
				if($landbedrooms >= $fields[4] and $landbathrooms >= $fields[5]){
					printf("%s at %s is looking for a house with a rent between \$%d/month and \$%d/month with %d bedrooms and %d bathrooms\n",$fields[0],$fields[1],$fields[2],$fields[3],$fields[4],$fields[5]);
					$landcount = $landcount + 1;
				}
			}
		}
	}
	
	if($landcount == 0){
		print("Nobody currently looking for housing matches your listing.\n 
		We have added your information to the database.\n");
	} else {
		print("We have also added you to our database\n");
	}
	
	$landname = substr($landname, 0, -1);
	$landnumber = substr($landnumber, 0, -1);
	$landaddress = substr($landaddress, 0, -1);
	open (my $mylandfile, '>>', 'landlords.csv') #open/create renter file in append mode
		or die "\nUnable to create/open landlords.csv"; #fail if file cannot be created/opened
	printf $mylandfile "%s,%s,%s,%d,%d,%d\n",$landname,$landnumber,$landaddress,$landprice,$landbedrooms,$landbathrooms;
	close $mylandfile;
	
}

userInput(); #run the program