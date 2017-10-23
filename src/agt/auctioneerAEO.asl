!do_auction("a1", "product(diamond_ring)").

+!do_auction(Id,P) <- // creates a scheme to coordinate the auction
	.concat("sch_",Id,SchName);
    makeArtifact(SchName, "ora4mas.nopl.SchemeBoard",["src/org/auctionos.xml", doAuction], SchArtId);
    debug(inspector_gui(on))[artifact_id(SchArtId)];
    setArgumentValue(auction,"Id",Id)[artifact_id(SchArtId)];
    setArgumentValue(auction,"Service",P)[artifact_id(SchArtId)];
    .my_name(Me); setOwner(Me)[artifact_id(SchArtId)];  // I am the owner of this scheme!
    focus(SchArtId);
    addScheme(SchName);  // set the group as responsible for the scheme
    commitMission(mAuctioneer)[artifact_id(SchArtId)].

+!start[scheme(Sch)] <- 
	?goalArgument(Sch,auction,"Id",Id);
    ?goalArgument(Sch,auction,"Service",S);
    .print("Start scheme ",Sch," for ",S);
	makeArtifact(Id, "auctionAEO.AuctionArtifact", [], ArtId);
    .print("Auction artifact created for ",S);
     Sch::focus(ArtId);
 //   .broadcast(achieve,focus(a1));
    Sch::start(S);
    .wait(500);
    !setOffer.
    
@p10[atomic] +!setOffer <-    
	lookupArtifact(a1,ArtId);
	?participants(N);
	if (N > 1) {
		?minOffer(P);
		setOffer(P+20);	
		!!setOffer;
	}.
	
+!setOffer.


+oblUnfulfilled( obligation(Ag,_,done(Sch,bid,Ag),_ ) )[artifact_id(AId)]  // it is the case that a bid was not achieved
   <- .print("Participant ",Ag," didn't bid on time! S/he will be placed in a blacklist");
       // TODO: implement an black list artifact
       admCommand("goalSatisfied(bid)")[artifact_id(AId)].

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
