import streamlit as st

st.title("Hello Streamlit")

st.subheader("Add a New User")

st.write("Welcome to your first web app!")

name = st.text_input("Enter your name")
email = st.text_input("Enter your email")

st.markdown('<h1 style="color:green">HI</h1>', unsafe_allow_html=True)

col1, col2, col3 = st.columns([2, 2, 1])
with col1:
    if st.button("Submit"):  # create the button
    # what to do if btn clicked
    # st.success("Submitted successfully!")  # green message
        st.write(f"{name} {email}")

choice = st.selectbox("Choose user", ["Alice", "Bob", "Charlie"])
st.write("You selected:", choice)

# adding link
# st.markdown('<a href="https://www.ynet.co.il" target="_blank">click her for: YNET</a>',
#            unsafe_allow_html=True)