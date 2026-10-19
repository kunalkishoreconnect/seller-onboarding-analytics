import streamlit as st
import pandas as pd
from pathlib import Path
st.set_page_config(page_title="Seller Onboarding Analytics",layout="wide")
st.title("Seller Onboarding Analytics")
st.warning("Synthetic portfolio dataset. Patterns were encoded in generation; no real business impact or causal effect is established.")
b=Path(__file__).parent
df=pd.read_csv(b/"events.csv")
device=st.selectbox("Device",["All"]+sorted(df.device_type.unique().tolist()))
channel=st.selectbox("Acquisition channel",["All"]+sorted(df.acquisition_channel.unique().tolist()))
if device!="All": df=df[df.device_type==device]
if channel!="All": df=df[df.acquisition_channel==channel]
steps=["account_created","business_details_completed","first_shipment_created","first_shipment_picked_up"]
counts=df.groupby("event_name").user_id.nunique().reindex(steps,fill_value=0)
st.caption("Generated sequences are ordered and all funnel steps occur within seven days of signup. SQL independently checks ordering and the window.")
st.bar_chart(counts)
t=counts.rename("Users").to_frame()
t["Signup conversion"]=counts/counts.iloc[0] if counts.iloc[0] else 0
t["Step conversion"]=counts/counts.shift(1)
t["Loss from previous step"]=counts.shift(1)-counts
st.dataframe(t)
st.subheader("Recommendation and experiment")
st.markdown((b/"INSIGHT_AND_EXPERIMENT.md").read_text())
st.download_button("Download filtered events",df.to_csv(index=False),"filtered_events.csv")
