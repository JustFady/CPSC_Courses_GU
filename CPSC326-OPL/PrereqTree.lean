inductive Course
| cpsc121 | cpsc122 | cpsc223 | cpsc224 | cpsc260
| cpsc326 | cpsc351 | cpsc346 | cpsc348 | cpsc391
| cpsc450 | cpsc491 | cpsc492 | cpsc499
deriving Repr

inductive TernaryTree
| empty
| node (val : Course) (left center right : TernaryTree)
deriving Repr

def sameCourse (a b : Course) : Bool :=
  match a, b with
  | Course.cpsc121, Course.cpsc121 => true
  | Course.cpsc122, Course.cpsc122 => true
  | Course.cpsc223, Course.cpsc223 => true
  | Course.cpsc224, Course.cpsc224 => true
  | Course.cpsc260, Course.cpsc260 => true
  | Course.cpsc326, Course.cpsc326 => true
  | Course.cpsc351, Course.cpsc351 => true
  | Course.cpsc346, Course.cpsc346 => true
  | Course.cpsc348, Course.cpsc348 => true
  | Course.cpsc391, Course.cpsc391 => true
  | Course.cpsc450, Course.cpsc450 => true
  | Course.cpsc491, Course.cpsc491 => true
  | Course.cpsc492, Course.cpsc492 => true
  | Course.cpsc499, Course.cpsc499 => true
  | _, _ => false -- returns false for any non matching pair

def johnsonTree : TernaryTree :=
  let leaf (n : Course) := TernaryTree.node n TernaryTree.empty TernaryTree.empty TernaryTree.empty

  let n492 := leaf Course.cpsc492
  let n499 := leaf Course.cpsc499
  let n491 := TernaryTree.node Course.cpsc491 n492 TernaryTree.empty TernaryTree.empty
  let n391 := TernaryTree.node Course.cpsc391 n491 n499 TernaryTree.empty

  let n224 := TernaryTree.node Course.cpsc224 n391 TernaryTree.empty TernaryTree.empty
  let n223 := TernaryTree.node Course.cpsc223 (leaf Course.cpsc326) (leaf Course.cpsc351) (leaf Course.cpsc450)
  let n260 := TernaryTree.node Course.cpsc260 (leaf Course.cpsc346) (leaf Course.cpsc348) TernaryTree.empty

  let n122 := TernaryTree.node Course.cpsc122 n223 n224 n260
  TernaryTree.node Course.cpsc121 n122 TernaryTree.empty TernaryTree.empty

def findPath (goal : Course) (tree : TernaryTree) (trail : List Course) : List Course :=
  match tree with
  | TernaryTree.empty => []
  | TernaryTree.node current left center right =>
    match sameCourse current goal with
    | true => trail -- found target
    | false =>
      let nextTrail := current :: trail -- add current class to the trail
      let leftRes := findPath goal left nextTrail
      match leftRes with
      | _ :: _ => leftRes -- if left isn't empty, it found the path
      | [] =>
        let centerRes := findPath goal center nextTrail
        match centerRes with
        | _ :: _ => centerRes -- if left was empty, check center
        | [] => findPath goal right nextTrail -- check right branch if others were empty

def rakeTree (t : TernaryTree) : List Course :=
  match t with
  | TernaryTree.empty => []
  | TernaryTree.node c l m r =>
      c :: List.append (rakeTree l) (List.append (rakeTree m) (rakeTree r)) -- flattens tree into a list

def hasCourse (history : List Course) (target : Course) : Bool :=
  match history with
  | [] => false
  | x :: xs => match sameCourse x target with | true => true | false => hasCourse xs target

def completionScore (myTree : TernaryTree) (schoolTree : TernaryTree) : Nat :=
  let takenList := rakeTree myTree
  let reqList := rakeTree schoolTree
  let rec tally (remaining : List Course) : Nat :=
    match remaining with
    | [] => 0
    | x :: xs => match hasCourse takenList x with
                 | true => 1 + tally xs -- increase counter if taken
                 | false => tally xs
  (tally reqList * 100) / List.length reqList -- calculate final percentage

-- results
def myHistory : TernaryTree :=
  let leaf (n : Course) := TernaryTree.node n TernaryTree.empty TernaryTree.empty TernaryTree.empty

  let my492 := leaf Course.cpsc492
  let my499 := leaf Course.cpsc499
  let my491 := TernaryTree.node Course.cpsc491 my492 TernaryTree.empty TernaryTree.empty
  let my391 := TernaryTree.node Course.cpsc391 my491 my499 TernaryTree.empty

  let my224 := TernaryTree.node Course.cpsc224 my391 TernaryTree.empty TernaryTree.empty
  let my223 := TernaryTree.node Course.cpsc223 (leaf Course.cpsc326) (leaf Course.cpsc351) TernaryTree.empty
  let my260 := TernaryTree.node Course.cpsc260 (leaf Course.cpsc346) (leaf Course.cpsc348) TernaryTree.empty

  let my122 := TernaryTree.node Course.cpsc122 my223 my224 my260
  TernaryTree.node Course.cpsc121 my122 TernaryTree.empty TernaryTree.empty



#print "prerequisites for cpsc 492:"
#eval findPath Course.cpsc492 johnsonTree [] -- searching for prereqs for 492

#print "percentage of requirements completed:"
#eval completionScore myHistory johnsonTree -- comparing my progress against requirements
