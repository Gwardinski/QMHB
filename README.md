# Product Overview

**QMHB** - *Quiz Master's Handbook* - is an app for creating and organising pub quizzes. You can also use QMHB to host a quiz, and have players join in either locally or online.

The Frontend is broken into 3 sections: **Library**, **Explore**, **Play**
 
 - **Library** allows you to create your own collection of Quizzes, Rounds, and Questions.
 - **Explore** allows you to browse through pre-created Quizzes, Rounds and Questions.
   - Users can “publish” their own Questions, Rounds and Quizzes to be used by other users.
   - I.e. *“Bob”* could create a Round called *“movies”* and then search online for film related Questions, find one created by *“Jeff”* and add it into their *“movies”* round.
- **Play** allows one user to host a Quiz - as a *“QuizMaster”* - and for other users to join in and partake in the Quiz

# Structure

There are 3 main data models: **Question** => **Round** => **Quiz**

- Users create **Questions**.

- Users create **Rounds**, and then add **Questions** to each **Round**.

- Users create **Quizzes**, and then add **Rounds** to that **Quiz**.

**Questions** can shared among many **Rounds**

**Rounds** can be shared among many **Quizzes**

**Quiz** and **Question** don’t need to know about each other, **Round** is the middle man in the relationship.
