<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default2" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" Runat="Server">
    <title>网上报价 | 诚信物流-可靠,快捷,实惠</title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style type="text/css">
.table th {
    background-color: #4F81BD !important;
    vertical-align: middle;
    color: #fff;
}
.table th, .table td {
    text-align: center;
    padding: 4px !important;
    line-height: 17px;
    border: 1px solid #fff;
}
.table tr:hover td {
    /* background-color: #FFFFA0; */
}
tr.sub-header td {
    background-color: #6EA0DC;
    color: #fff;
}
tr.odd td {
    background-color: #EBEBF5;
}
tr.even td {
    background-color: #F5F0F0;
}
.table tr.hightlight td {
    background-color: #FFFFA0;
}
</style>
          <ul class="breadcrumb" style="background:none;margin-top:15px">
                
            </ul>
            
            
            

<p style="font-size:14px;margin-top:15px">
    <span style="font-size:18px;font-weight:bold">提示: </span>下表显示的是对某一产品在某一公斤段下的<strong>单箱价格</strong>，对于列出多箱的产品(如Bpost Interlink 取件)，一次性发的<strong>箱数越多越优惠</strong>。人民币对英镑汇率10。
    
    <br/>请<a href="/accounts/login/?next=/prices/">登录</a>之后查看你的折后价。
    
</p>

<table class="table">
    <tr>
        <th>重量(公斤)</th>
        
        <th >Bpost -<br />自送仓库</th>
        
        <th >Bpost -<br />Collect+ 便利店递送</th>
        
        <th >Bpost -<br />Parcelforce取件</th>
        
        <th colspan="3">Bpost -<br />UKMail 取件</th>
        
        <th colspan="3">Bpost -<br />Interlink 取件</th>
        
        <th >China Economy<br />自送邮局</th>
        
        <th >China Economy<br />自送Depot</th>
        
        <th >China Economy<br />上门取件</th>
        
        <th >Global Priority<br />自送邮局</th>
        
        <th >Global Priority<br />上门取件</th>
        
    </tr>
    <tr class="sub-header">
        <td></td>
        
            
                <td>1箱</td>
            
        
            
                <td>1箱</td>
            
        
            
                <td>1箱</td>
            
        
            
                <td>1箱</td>
                <td>4箱</td>
                <td>8箱</td>
            
        
            
                <td>1箱</td>
                <td>4箱</td>
                <td>8箱</td>
            
        
            
                <td>1箱</td>
            
        
            
                <td>1箱</td>
            
        
            
                <td>1箱</td>
            
        
            
                <td>1箱</td>
            
        
            
                <td>1箱</td>
            
        
    </tr>

    
    <tr class="odd ">
        <td>0.01-0.50</td>
        
            
                <td>£12.83</td>
            
        
            
                <td>£15.83</td>
            
        
            
                <td>£17.83</td>
            
        
            
                <td>£19.83</td>
                <td>£14.58</td>
                <td>£13.71</td>
            
        
            
                <td>£26.46</td>
                <td>£16.24</td>
                <td>£14.54</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£26.83</td>
            
        
            
                <td>£26.83</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>0.51-1.00</td>
        
            
                <td>£13.63</td>
            
        
            
                <td>£16.63</td>
            
        
            
                <td>£18.63</td>
            
        
            
                <td>£20.63</td>
                <td>£15.38</td>
                <td>£14.51</td>
            
        
            
                <td>£27.26</td>
                <td>£17.04</td>
                <td>£15.34</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£29.30</td>
            
        
            
                <td>£29.30</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>1.01-1.50</td>
        
            
                <td>£14.45</td>
            
        
            
                <td>£17.45</td>
            
        
            
                <td>£19.45</td>
            
        
            
                <td>£21.45</td>
                <td>£16.20</td>
                <td>£15.33</td>
            
        
            
                <td>£28.08</td>
                <td>£17.86</td>
                <td>£16.16</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£31.78</td>
            
        
            
                <td>£31.78</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>1.51-2.00</td>
        
            
                <td>£15.27</td>
            
        
            
                <td>£18.27</td>
            
        
            
                <td>£20.27</td>
            
        
            
                <td>£22.27</td>
                <td>£17.02</td>
                <td>£16.15</td>
            
        
            
                <td>£28.90</td>
                <td>£18.68</td>
                <td>£17.01</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£34.25</td>
            
        
            
                <td>£34.25</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>2.01-2.50</td>
        
            
                <td>£15.87</td>
            
        
            
                <td>£18.87</td>
            
        
            
                <td>£20.87</td>
            
        
            
                <td>£22.87</td>
                <td>£17.62</td>
                <td>£16.75</td>
            
        
            
                <td>£29.50</td>
                <td>£19.28</td>
                <td>£17.72</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£36.73</td>
            
        
            
                <td>£36.73</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>2.51-3.00</td>
        
            
                <td>£16.45</td>
            
        
            
                <td>£19.45</td>
            
        
            
                <td>£21.45</td>
            
        
            
                <td>£23.45</td>
                <td>£18.20</td>
                <td>£17.33</td>
            
        
            
                <td>£30.08</td>
                <td>£19.86</td>
                <td>£18.42</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£38.63</td>
            
        
            
                <td>£38.63</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>3.01-3.50</td>
        
            
                <td>£17.66</td>
            
        
            
                <td>£20.66</td>
            
        
            
                <td>£22.66</td>
            
        
            
                <td>£24.66</td>
                <td>£19.41</td>
                <td>£18.62</td>
            
        
            
                <td>£31.29</td>
                <td>£21.07</td>
                <td>£19.74</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£40.53</td>
            
        
            
                <td>£40.53</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>3.51-4.00</td>
        
            
                <td>£18.86</td>
            
        
            
                <td>£21.86</td>
            
        
            
                <td>£23.86</td>
            
        
            
                <td>£25.86</td>
                <td>£20.61</td>
                <td>£19.92</td>
            
        
            
                <td>£32.49</td>
                <td>£22.33</td>
                <td>£21.06</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£42.43</td>
            
        
            
                <td>£42.43</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>4.01-4.50</td>
        
            
                <td>£20.06</td>
            
        
            
                <td>£23.06</td>
            
        
            
                <td>£25.06</td>
            
        
            
                <td>£27.06</td>
                <td>£21.81</td>
                <td>£21.23</td>
            
        
            
                <td>£33.69</td>
                <td>£23.64</td>
                <td>£22.37</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£44.33</td>
            
        
            
                <td>£44.33</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>4.51-5.00</td>
        
            
                <td>£21.25</td>
            
        
            
                <td>£24.25</td>
            
        
            
                <td>£26.25</td>
            
        
            
                <td>£28.25</td>
                <td>£23.00</td>
                <td>£22.52</td>
            
        
            
                <td>£34.88</td>
                <td>£24.95</td>
                <td>£23.68</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£46.23</td>
            
        
            
                <td>£46.23</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>5.01-5.50</td>
        
            
                <td>£22.33</td>
            
        
            
                <td>£25.33</td>
            
        
            
                <td>£27.33</td>
            
        
            
                <td>£29.33</td>
                <td>£24.08</td>
                <td>£23.71</td>
            
        
            
                <td>£35.96</td>
                <td>£26.14</td>
                <td>£24.87</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£48.33</td>
            
        
            
                <td>£48.33</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>5.51-6.00</td>
        
            
                <td>£23.43</td>
            
        
            
                <td>£26.43</td>
            
        
            
                <td>£28.43</td>
            
        
            
                <td>£30.43</td>
                <td>£25.18</td>
                <td>£24.91</td>
            
        
            
                <td>£37.06</td>
                <td>£27.36</td>
                <td>£26.09</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£50.43</td>
            
        
            
                <td>£50.43</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>6.01-6.50</td>
        
            
                <td>£24.74</td>
            
        
            
                <td>£27.74</td>
            
        
            
                <td>£29.74</td>
            
        
            
                <td>£31.74</td>
                <td>£26.55</td>
                <td>£26.33</td>
            
        
            
                <td>£38.37</td>
                <td>£28.78</td>
                <td>£27.51</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£52.53</td>
            
        
            
                <td>£52.53</td>
            
        
    </tr>
    
    <tr class="even hightlight">
        <td>6.51-7.00</td>
        
            
                <td>£26.04</td>
            
        
            
                <td>£29.04</td>
            
        
            
                <td>£31.04</td>
            
        
            
                <td>£33.04</td>
                <td>£27.95</td>
                <td>£27.73</td>
            
        
            
                <td>£39.67</td>
                <td>£30.20</td>
                <td>£28.93</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£27.00</td>
            
        
            
                <td>£29.96</td>
            
        
            
                <td>£54.63</td>
            
        
            
                <td>£54.63</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>7.01-7.50</td>
        
            
                <td>£27.37</td>
            
        
            
                <td>£30.37</td>
            
        
            
                <td>£32.37</td>
            
        
            
                <td>£34.37</td>
                <td>£29.39</td>
                <td>£29.17</td>
            
        
            
                <td>£41.00</td>
                <td>£31.64</td>
                <td>£30.37</td>
            
        
            
                <td>£32.25</td>
            
        
            
                <td>£29.70</td>
            
        
            
                <td>£32.25</td>
            
        
            
                <td>£56.73</td>
            
        
            
                <td>£56.73</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>7.51-8.00</td>
        
            
                <td>£28.63</td>
            
        
            
                <td>£31.63</td>
            
        
            
                <td>£33.63</td>
            
        
            
                <td>£35.63</td>
                <td>£30.75</td>
                <td>£30.53</td>
            
        
            
                <td>£42.26</td>
                <td>£33.02</td>
                <td>£31.75</td>
            
        
            
                <td>£32.25</td>
            
        
            
                <td>£29.70</td>
            
        
            
                <td>£32.25</td>
            
        
            
                <td>£58.83</td>
            
        
            
                <td>£58.83</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>8.01-8.50</td>
        
            
                <td>£29.93</td>
            
        
            
                <td>£32.93</td>
            
        
            
                <td>£34.93</td>
            
        
            
                <td>£36.93</td>
                <td>£32.16</td>
                <td>£31.94</td>
            
        
            
                <td>£43.56</td>
                <td>£34.43</td>
                <td>£33.16</td>
            
        
            
                <td>£35.47</td>
            
        
            
                <td>£31.81</td>
            
        
            
                <td>£35.47</td>
            
        
            
                <td>£60.93</td>
            
        
            
                <td>£60.93</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>8.51-9.00</td>
        
            
                <td>£31.24</td>
            
        
            
                <td>£34.24</td>
            
        
            
                <td>£36.24</td>
            
        
            
                <td>£38.24</td>
                <td>£33.57</td>
                <td>£33.35</td>
            
        
            
                <td>£44.87</td>
                <td>£35.86</td>
                <td>£34.59</td>
            
        
            
                <td>£35.47</td>
            
        
            
                <td>£31.81</td>
            
        
            
                <td>£35.47</td>
            
        
            
                <td>£63.03</td>
            
        
            
                <td>£63.03</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>9.01-9.50</td>
        
            
                <td>£32.54</td>
            
        
            
                <td>£35.54</td>
            
        
            
                <td>£37.54</td>
            
        
            
                <td>£39.54</td>
                <td>£34.98</td>
                <td>£34.76</td>
            
        
            
                <td>£46.17</td>
                <td>£37.27</td>
                <td>£36.00</td>
            
        
            
                <td>£37.62</td>
            
        
            
                <td>£33.91</td>
            
        
            
                <td>£37.62</td>
            
        
            
                <td>£65.13</td>
            
        
            
                <td>£65.13</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>9.51-10.00</td>
        
            
                <td>£33.82</td>
            
        
            
                <td>£36.82</td>
            
        
            
                <td>£38.82</td>
            
        
            
                <td>£40.82</td>
                <td>£36.36</td>
                <td>£36.14</td>
            
        
            
                <td>£47.45</td>
                <td>£38.67</td>
                <td>£37.40</td>
            
        
            
                <td>£37.62</td>
            
        
            
                <td>£33.91</td>
            
        
            
                <td>£37.62</td>
            
        
            
                <td>£67.23</td>
            
        
            
                <td>£67.23</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>10.01-10.50</td>
        
            
                <td>£34.71</td>
            
        
            
                <td>£37.71</td>
            
        
            
                <td>£39.71</td>
            
        
            
                <td>£41.71</td>
                <td>£37.36</td>
                <td>£37.14</td>
            
        
            
                <td>£48.34</td>
                <td>£39.67</td>
                <td>£38.40</td>
            
        
            
                <td>£39.77</td>
            
        
            
                <td>£36.02</td>
            
        
            
                <td>£39.77</td>
            
        
            
                <td>£68.45</td>
            
        
            
                <td>£68.45</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>10.51-11.00</td>
        
            
                <td>£35.60</td>
            
        
            
                <td>£38.60</td>
            
        
            
                <td>£40.60</td>
            
        
            
                <td>£42.60</td>
                <td>£38.35</td>
                <td>£38.13</td>
            
        
            
                <td>£49.23</td>
                <td>£40.68</td>
                <td>£39.41</td>
            
        
            
                <td>£39.77</td>
            
        
            
                <td>£36.02</td>
            
        
            
                <td>£39.77</td>
            
        
            
                <td>£69.68</td>
            
        
            
                <td>£69.68</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>11.01-11.50</td>
        
            
                <td>£36.50</td>
            
        
            
                <td>£39.50</td>
            
        
            
                <td>£41.50</td>
            
        
            
                <td>£43.50</td>
                <td>£39.36</td>
                <td>£39.14</td>
            
        
            
                <td>£50.13</td>
                <td>£41.69</td>
                <td>£40.42</td>
            
        
            
                <td>£41.92</td>
            
        
            
                <td>£38.12</td>
            
        
            
                <td>£41.92</td>
            
        
            
                <td>£70.90</td>
            
        
            
                <td>£70.90</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>11.51-12.00</td>
        
            
                <td>£37.37</td>
            
        
            
                <td>£40.37</td>
            
        
            
                <td>£42.37</td>
            
        
            
                <td>£44.37</td>
                <td>£40.33</td>
                <td>£40.11</td>
            
        
            
                <td>£51.00</td>
                <td>£42.68</td>
                <td>£41.41</td>
            
        
            
                <td>£41.92</td>
            
        
            
                <td>£38.12</td>
            
        
            
                <td>£41.92</td>
            
        
            
                <td>£72.13</td>
            
        
            
                <td>£72.13</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>12.01-12.50</td>
        
            
                <td>£38.25</td>
            
        
            
                <td>£41.25</td>
            
        
            
                <td>£43.25</td>
            
        
            
                <td>£45.25</td>
                <td>£41.32</td>
                <td>£41.10</td>
            
        
            
                <td>£51.88</td>
                <td>£43.67</td>
                <td>£42.40</td>
            
        
            
                <td>£44.07</td>
            
        
            
                <td>£40.23</td>
            
        
            
                <td>£44.07</td>
            
        
            
                <td>£73.35</td>
            
        
            
                <td>£73.35</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>12.51-13.00</td>
        
            
                <td>£39.14</td>
            
        
            
                <td>£42.14</td>
            
        
            
                <td>£44.14</td>
            
        
            
                <td>£46.14</td>
                <td>£42.31</td>
                <td>£42.09</td>
            
        
            
                <td>£52.77</td>
                <td>£44.68</td>
                <td>£43.41</td>
            
        
            
                <td>£44.07</td>
            
        
            
                <td>£40.23</td>
            
        
            
                <td>£44.07</td>
            
        
            
                <td>£74.58</td>
            
        
            
                <td>£74.58</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>13.01-13.50</td>
        
            
                <td>£40.00</td>
            
        
            
                <td>£43.00</td>
            
        
            
                <td>£45.00</td>
            
        
            
                <td>£47.00</td>
                <td>£43.28</td>
                <td>£43.06</td>
            
        
            
                <td>£53.63</td>
                <td>£45.65</td>
                <td>£44.38</td>
            
        
            
                <td>£46.22</td>
            
        
            
                <td>£42.34</td>
            
        
            
                <td>£46.22</td>
            
        
            
                <td>£75.80</td>
            
        
            
                <td>£75.80</td>
            
        
    </tr>
    
    <tr class="even hightlight">
        <td>13.51-14.00</td>
        
            
                <td>£40.90</td>
            
        
            
                <td>£43.90</td>
            
        
            
                <td>£45.90</td>
            
        
            
                <td>£47.90</td>
                <td>£44.28</td>
                <td>£44.06</td>
            
        
            
                <td>£54.53</td>
                <td>£46.67</td>
                <td>£45.40</td>
            
        
            
                <td>£46.22</td>
            
        
            
                <td>£42.34</td>
            
        
            
                <td>£46.22</td>
            
        
            
                <td>£77.03</td>
            
        
            
                <td>£77.03</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>14.01-14.50</td>
        
            
                <td>£41.79</td>
            
        
            
                <td>£44.79</td>
            
        
            
                <td>£46.79</td>
            
        
            
                <td>£48.79</td>
                <td>£45.28</td>
                <td>£45.06</td>
            
        
            
                <td>£55.42</td>
                <td>£47.67</td>
                <td>£46.40</td>
            
        
            
                <td>£48.37</td>
            
        
            
                <td>£44.44</td>
            
        
            
                <td>£48.37</td>
            
        
            
                <td>£78.25</td>
            
        
            
                <td>£78.25</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>14.51-15.00</td>
        
            
                <td>£42.69</td>
            
        
            
                <td>£45.69</td>
            
        
            
                <td>£47.69</td>
            
        
            
                <td>£49.69</td>
                <td>£46.28</td>
                <td>£46.06</td>
            
        
            
                <td>£56.32</td>
                <td>£48.69</td>
                <td>£47.42</td>
            
        
            
                <td>£48.37</td>
            
        
            
                <td>£44.44</td>
            
        
            
                <td>£48.37</td>
            
        
            
                <td>£79.48</td>
            
        
            
                <td>£79.48</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>15.01-15.50</td>
        
            
                <td>£43.98</td>
            
        
            
                <td>£46.98</td>
            
        
            
                <td>£48.98</td>
            
        
            
                <td>£50.98</td>
                <td>£47.68</td>
                <td>£47.46</td>
            
        
            
                <td>£57.72</td>
                <td>£50.09</td>
                <td>£48.82</td>
            
        
            
                <td>£50.53</td>
            
        
            
                <td>£46.55</td>
            
        
            
                <td>£50.53</td>
            
        
            
                <td>£81.10</td>
            
        
            
                <td>£81.10</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>15.51-16.00</td>
        
            
                <td>£45.27</td>
            
        
            
                <td>£48.27</td>
            
        
            
                <td>£50.27</td>
            
        
            
                <td>£52.27</td>
                <td>£49.07</td>
                <td>£48.85</td>
            
        
            
                <td>£59.13</td>
                <td>£51.50</td>
                <td>£50.23</td>
            
        
            
                <td>£50.53</td>
            
        
            
                <td>£46.55</td>
            
        
            
                <td>£50.53</td>
            
        
            
                <td>£82.73</td>
            
        
            
                <td>£82.73</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>16.01-16.50</td>
        
            
                <td>£46.57</td>
            
        
            
                <td>£49.57</td>
            
        
            
                <td>£51.57</td>
            
        
            
                <td>£53.57</td>
                <td>£50.48</td>
                <td>£50.26</td>
            
        
            
                <td>£60.55</td>
                <td>£52.91</td>
                <td>£51.64</td>
            
        
            
                <td>£52.68</td>
            
        
            
                <td>£48.65</td>
            
        
            
                <td>£52.68</td>
            
        
            
                <td>£84.35</td>
            
        
            
                <td>£84.35</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>16.51-17.00</td>
        
            
                <td>£47.87</td>
            
        
            
                <td>£50.87</td>
            
        
            
                <td>£52.87</td>
            
        
            
                <td>£54.87</td>
                <td>£51.88</td>
                <td>£51.66</td>
            
        
            
                <td>£61.96</td>
                <td>£54.33</td>
                <td>£53.06</td>
            
        
            
                <td>£52.68</td>
            
        
            
                <td>£48.65</td>
            
        
            
                <td>£52.68</td>
            
        
            
                <td>£85.98</td>
            
        
            
                <td>£85.98</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>17.01-17.50</td>
        
            
                <td>£49.17</td>
            
        
            
                <td>£52.17</td>
            
        
            
                <td>£54.17</td>
            
        
            
                <td>£56.17</td>
                <td>£53.29</td>
                <td>£53.07</td>
            
        
            
                <td>£63.37</td>
                <td>£55.74</td>
                <td>£54.47</td>
            
        
            
                <td>£54.83</td>
            
        
            
                <td>£50.76</td>
            
        
            
                <td>£54.83</td>
            
        
            
                <td>£87.60</td>
            
        
            
                <td>£87.60</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>17.51-18.00</td>
        
            
                <td>£50.47</td>
            
        
            
                <td>£53.47</td>
            
        
            
                <td>£55.47</td>
            
        
            
                <td>£57.47</td>
                <td>£54.69</td>
                <td>£54.47</td>
            
        
            
                <td>£64.79</td>
                <td>£57.16</td>
                <td>£55.89</td>
            
        
            
                <td>£54.83</td>
            
        
            
                <td>£50.76</td>
            
        
            
                <td>£54.83</td>
            
        
            
                <td>£89.23</td>
            
        
            
                <td>£89.23</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>18.01-18.50</td>
        
            
                <td>£51.77</td>
            
        
            
                <td>£54.77</td>
            
        
            
                <td>£56.77</td>
            
        
            
                <td>£58.77</td>
                <td>£56.10</td>
                <td>£55.88</td>
            
        
            
                <td>£66.21</td>
                <td>£58.57</td>
                <td>£57.30</td>
            
        
            
                <td>£56.98</td>
            
        
            
                <td>£52.87</td>
            
        
            
                <td>£56.98</td>
            
        
            
                <td>£90.85</td>
            
        
            
                <td>£90.85</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>18.51-19.00</td>
        
            
                <td>£53.07</td>
            
        
            
                <td>£56.07</td>
            
        
            
                <td>£58.07</td>
            
        
            
                <td>£60.07</td>
                <td>£57.50</td>
                <td>£57.28</td>
            
        
            
                <td>£67.62</td>
                <td>£59.99</td>
                <td>£58.72</td>
            
        
            
                <td>£56.98</td>
            
        
            
                <td>£52.87</td>
            
        
            
                <td>£56.98</td>
            
        
            
                <td>£92.48</td>
            
        
            
                <td>£92.48</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>19.01-19.50</td>
        
            
                <td>£54.37</td>
            
        
            
                <td>£57.37</td>
            
        
            
                <td>£59.37</td>
            
        
            
                <td>£61.37</td>
                <td>£58.91</td>
                <td>£58.69</td>
            
        
            
                <td>£69.03</td>
                <td>£61.40</td>
                <td>£60.13</td>
            
        
            
                <td>£59.13</td>
            
        
            
                <td>£54.97</td>
            
        
            
                <td>£59.13</td>
            
        
            
                <td>£94.10</td>
            
        
            
                <td>£94.10</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>19.51-20.00</td>
        
            
                <td>£55.66</td>
            
        
            
                <td>£58.66</td>
            
        
            
                <td>£60.66</td>
            
        
            
                <td>£62.66</td>
                <td>£60.30</td>
                <td>£60.08</td>
            
        
            
                <td>£70.44</td>
                <td>£62.81</td>
                <td>£61.54</td>
            
        
            
                <td>£59.13</td>
            
        
            
                <td>£54.97</td>
            
        
            
                <td>£59.13</td>
            
        
            
                <td>£95.73</td>
            
        
            
                <td>£95.73</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>20.01-20.50</td>
        
            
                <td>£68.66</td>
            
        
            
                <td>£71.66</td>
            
        
            
                <td>£73.66</td>
            
        
            
                <td>£75.66</td>
                <td>£73.41</td>
                <td>£73.19</td>
            
        
            
                <td>£83.56</td>
                <td>£75.92</td>
                <td>£74.65</td>
            
        
            
                <td>£61.28</td>
            
        
            
                <td>£57.08</td>
            
        
            
                <td>£61.28</td>
            
        
            
                <td>£97.35</td>
            
        
            
                <td>£97.35</td>
            
        
    </tr>
    
    <tr class="even hightlight">
        <td>20.51-21.00</td>
        
            
                <td>£68.66</td>
            
        
            
                <td>£71.66</td>
            
        
            
                <td>£73.66</td>
            
        
            
                <td>£75.66</td>
                <td>£73.51</td>
                <td>£73.29</td>
            
        
            
                <td>£83.67</td>
                <td>£76.04</td>
                <td>£74.77</td>
            
        
            
                <td>£61.28</td>
            
        
            
                <td>£57.08</td>
            
        
            
                <td>£61.28</td>
            
        
            
                <td>£98.98</td>
            
        
            
                <td>£98.98</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>21.01-21.50</td>
        
            
                <td>£68.66</td>
            
        
            
                <td>£71.66</td>
            
        
            
                <td>£73.66</td>
            
        
            
                <td>£75.66</td>
                <td>£73.62</td>
                <td>£73.40</td>
            
        
            
                <td>£83.78</td>
                <td>£76.15</td>
                <td>£74.88</td>
            
        
            
                <td>£63.43</td>
            
        
            
                <td>£59.18</td>
            
        
            
                <td>£63.43</td>
            
        
            
                <td>£100.60</td>
            
        
            
                <td>£100.60</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>21.51-22.00</td>
        
            
                <td>£68.66</td>
            
        
            
                <td>£71.66</td>
            
        
            
                <td>£73.66</td>
            
        
            
                <td>£75.66</td>
                <td>£73.72</td>
                <td>£73.50</td>
            
        
            
                <td>£83.90</td>
                <td>£76.27</td>
                <td>£75.00</td>
            
        
            
                <td>£63.43</td>
            
        
            
                <td>£59.18</td>
            
        
            
                <td>£63.43</td>
            
        
            
                <td>£102.23</td>
            
        
            
                <td>£102.23</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>22.01-22.50</td>
        
            
                <td>£68.66</td>
            
        
            
                <td>£71.66</td>
            
        
            
                <td>£73.66</td>
            
        
            
                <td>£75.66</td>
                <td>£73.83</td>
                <td>£73.61</td>
            
        
            
                <td>£84.02</td>
                <td>£76.38</td>
                <td>£75.11</td>
            
        
            
                <td>£65.58</td>
            
        
            
                <td>£61.29</td>
            
        
            
                <td>£65.58</td>
            
        
            
                <td>£103.85</td>
            
        
            
                <td>£103.85</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>22.51-23.00</td>
        
            
                <td>£68.66</td>
            
        
            
                <td>£71.66</td>
            
        
            
                <td>£73.66</td>
            
        
            
                <td>£75.66</td>
                <td>£73.93</td>
                <td>£73.71</td>
            
        
            
                <td>£84.13</td>
                <td>£76.50</td>
                <td>£75.23</td>
            
        
            
                <td>£65.58</td>
            
        
            
                <td>£61.29</td>
            
        
            
                <td>£65.58</td>
            
        
            
                <td>£105.48</td>
            
        
            
                <td>£105.48</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>23.01-23.50</td>
        
            
                <td>£68.66</td>
            
        
            
                <td>£71.66</td>
            
        
            
                <td>£73.66</td>
            
        
            
                <td>£75.66</td>
                <td>£74.04</td>
                <td>£73.82</td>
            
        
            
                <td>£84.24</td>
                <td>£76.61</td>
                <td>£75.34</td>
            
        
            
                <td>£67.73</td>
            
        
            
                <td>£63.40</td>
            
        
            
                <td>£67.73</td>
            
        
            
                <td>£107.10</td>
            
        
            
                <td>£107.10</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>23.51-24.00</td>
        
            
                <td>£68.66</td>
            
        
            
                <td>£71.66</td>
            
        
            
                <td>£73.66</td>
            
        
            
                <td>£75.66</td>
                <td>£74.14</td>
                <td>£73.92</td>
            
        
            
                <td>£84.36</td>
                <td>£76.73</td>
                <td>£75.46</td>
            
        
            
                <td>£67.73</td>
            
        
            
                <td>£63.40</td>
            
        
            
                <td>£67.73</td>
            
        
            
                <td>£108.73</td>
            
        
            
                <td>£108.73</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>24.01-24.50</td>
        
            
                <td>£68.66</td>
            
        
            
                <td>£71.66</td>
            
        
            
                <td>£73.66</td>
            
        
            
                <td>£75.66</td>
                <td>£74.25</td>
                <td>£74.03</td>
            
        
            
                <td>£84.48</td>
                <td>£76.84</td>
                <td>£75.57</td>
            
        
            
                <td>£69.88</td>
            
        
            
                <td>£65.50</td>
            
        
            
                <td>£69.88</td>
            
        
            
                <td>£110.35</td>
            
        
            
                <td>£110.35</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>24.51-25.00</td>
        
            
                <td>£68.66</td>
            
        
            
                <td>£71.66</td>
            
        
            
                <td>£73.66</td>
            
        
            
                <td>£75.66</td>
                <td>£74.35</td>
                <td>£74.13</td>
            
        
            
                <td>£84.59</td>
                <td>£76.96</td>
                <td>£75.69</td>
            
        
            
                <td>£69.88</td>
            
        
            
                <td>£65.50</td>
            
        
            
                <td>£69.88</td>
            
        
            
                <td>£111.98</td>
            
        
            
                <td>£111.98</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>25.01-25.50</td>
        
            
                <td>£81.65</td>
            
        
            
                <td>£84.65</td>
            
        
            
                <td>£86.65</td>
            
        
            
                <td>£88.75</td>
                <td>£87.45</td>
                <td>£87.23</td>
            
        
            
                <td>£97.69</td>
                <td>£90.06</td>
                <td>£88.79</td>
            
        
            
                <td>£72.03</td>
            
        
            
                <td>£67.61</td>
            
        
            
                <td>£72.03</td>
            
        
            
                <td>£113.60</td>
            
        
            
                <td>£113.60</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>25.51-26.00</td>
        
            
                <td>£81.65</td>
            
        
            
                <td>£84.65</td>
            
        
            
                <td>£86.65</td>
            
        
            
                <td>£88.86</td>
                <td>£87.55</td>
                <td>£87.33</td>
            
        
            
                <td>£97.81</td>
                <td>£90.18</td>
                <td>£88.91</td>
            
        
            
                <td>£72.03</td>
            
        
            
                <td>£67.61</td>
            
        
            
                <td>£72.03</td>
            
        
            
                <td>£115.23</td>
            
        
            
                <td>£115.23</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>26.01-26.50</td>
        
            
                <td>£81.65</td>
            
        
            
                <td>£84.65</td>
            
        
            
                <td>£86.65</td>
            
        
            
                <td>£88.97</td>
                <td>£87.66</td>
                <td>£87.44</td>
            
        
            
                <td>£97.93</td>
                <td>£90.29</td>
                <td>£89.02</td>
            
        
            
                <td>£74.18</td>
            
        
            
                <td>£69.71</td>
            
        
            
                <td>£74.18</td>
            
        
            
                <td>£116.85</td>
            
        
            
                <td>£116.85</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>26.51-27.00</td>
        
            
                <td>£81.65</td>
            
        
            
                <td>£84.65</td>
            
        
            
                <td>£86.65</td>
            
        
            
                <td>£89.07</td>
                <td>£87.76</td>
                <td>£87.54</td>
            
        
            
                <td>£98.04</td>
                <td>£90.41</td>
                <td>£89.14</td>
            
        
            
                <td>£74.18</td>
            
        
            
                <td>£69.71</td>
            
        
            
                <td>£74.18</td>
            
        
            
                <td>£118.48</td>
            
        
            
                <td>£118.48</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>27.01-27.50</td>
        
            
                <td>£81.65</td>
            
        
            
                <td>£84.65</td>
            
        
            
                <td>£86.65</td>
            
        
            
                <td>£89.17</td>
                <td>£87.87</td>
                <td>£87.65</td>
            
        
            
                <td>£98.15</td>
                <td>£90.52</td>
                <td>£89.25</td>
            
        
            
                <td>£76.33</td>
            
        
            
                <td>£71.82</td>
            
        
            
                <td>£76.33</td>
            
        
            
                <td>£120.10</td>
            
        
            
                <td>£120.10</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>27.51-28.00</td>
        
            
                <td>£81.65</td>
            
        
            
                <td>£84.65</td>
            
        
            
                <td>£86.65</td>
            
        
            
                <td>£89.28</td>
                <td>£87.97</td>
                <td>£87.75</td>
            
        
            
                <td>£98.27</td>
                <td>£90.64</td>
                <td>£89.37</td>
            
        
            
                <td>£76.33</td>
            
        
            
                <td>£71.82</td>
            
        
            
                <td>£76.33</td>
            
        
            
                <td>£121.73</td>
            
        
            
                <td>£121.73</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>28.01-28.50</td>
        
            
                <td>£81.65</td>
            
        
            
                <td>£84.65</td>
            
        
            
                <td>£86.65</td>
            
        
            
                <td>£89.39</td>
                <td>£88.08</td>
                <td>£87.86</td>
            
        
            
                <td>£98.39</td>
                <td>£90.75</td>
                <td>£89.48</td>
            
        
            
                <td>£78.48</td>
            
        
            
                <td>£73.93</td>
            
        
            
                <td>£78.48</td>
            
        
            
                <td>£123.35</td>
            
        
            
                <td>£123.35</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>28.51-29.00</td>
        
            
                <td>£81.65</td>
            
        
            
                <td>£84.65</td>
            
        
            
                <td>£86.65</td>
            
        
            
                <td>£89.49</td>
                <td>£88.18</td>
                <td>£87.96</td>
            
        
            
                <td>£98.50</td>
                <td>£90.87</td>
                <td>£89.60</td>
            
        
            
                <td>£78.48</td>
            
        
            
                <td>£73.93</td>
            
        
            
                <td>£78.48</td>
            
        
            
                <td>£124.98</td>
            
        
            
                <td>£124.98</td>
            
        
    </tr>
    
    <tr class="odd ">
        <td>29.01-29.50</td>
        
            
                <td>£81.65</td>
            
        
            
                <td>£84.65</td>
            
        
            
                <td>£86.65</td>
            
        
            
                <td>£89.59</td>
                <td>£88.29</td>
                <td>£88.07</td>
            
        
            
                <td>£98.61</td>
                <td>£90.98</td>
                <td>£89.71</td>
            
        
            
                <td>£80.64</td>
            
        
            
                <td>£76.03</td>
            
        
            
                <td>£80.64</td>
            
        
            
                <td>£126.60</td>
            
        
            
                <td>£126.60</td>
            
        
    </tr>
    
    <tr class="even ">
        <td>29.51-30.00</td>
        
            
                <td>£81.65</td>
            
        
            
                <td>£84.65</td>
            
        
            
                <td>£86.65</td>
            
        
            
                <td>£89.70</td>
                <td>£88.39</td>
                <td>£88.17</td>
            
        
            
                <td>£98.73</td>
                <td>£91.10</td>
                <td>£89.83</td>
            
        
            
                <td>£80.64</td>
            
        
            
                <td>£76.03</td>
            
        
            
                <td>£80.64</td>
            
        
            
                <td>£128.23</td>
            
        
            
                <td>£128.23</td>
            
        
    </tr>
    

    <tr class="odd">
        <td>超出部分每0.5公斤</td>
        
            
                <td>--</td>
            
        
            
                <td>--</td>
            
        
            
                <td>--</td>
            
        
            
                <td>--</td>
                <td>--</td>
                <td>--</td>
            
        
            
                <td>--</td>
                <td>--</td>
                <td>--</td>
            
        
            
                <td>--</td>
            
        
            
                <td>--</td>
            
        
            
                <td>--</td>
            
        
            
                <td>£1.63</td>
            
        
            
                <td>£1.63</td>
            
        
    </tr>
</table>
    <script>
        $('.main-menu .zy').parent().siblings().removeClass('active').end().end().addClass('active');
</script>
</asp:Content>

